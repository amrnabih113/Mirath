import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'cache_record.dart';

class HiveCacheService {
  static const String _boxName = 'mirath_cache';
  static const Duration defaultTtl = Duration(minutes: 15);

  late final Box<CacheRecord> _box;

  HiveCacheService._();

  static Future<HiveCacheService> init() async {
    if (!Hive.isAdapterRegistered(29)) {
      Hive.registerAdapter(CacheRecordAdapter());
    }

    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    final service = HiveCacheService._();
    service._box = await Hive.openBox<CacheRecord>(_boxName);
    return service;
  }

  Future<void> putJson(
    String key,
    Map<String, dynamic> payload, {
    Duration ttl = defaultTtl,
  }) async {
    await _box.put(
      key,
      CacheRecord(
        key: key,
        payload: jsonEncode(payload),
        cachedAt: DateTime.now(),
        ttlSeconds: ttl.inSeconds,
      ),
    );
  }

  Future<void> putJsonList(
    String key,
    List<Map<String, dynamic>> payload, {
    Duration ttl = defaultTtl,
  }) async {
    await putJson(key, {'items': payload}, ttl: ttl);
  }

  Future<Map<String, dynamic>?> getJson(
    String key, {
    bool allowStale = false,
  }) async {
    final record = _box.get(key);
    if (record == null) {
      return null;
    }

    if (!allowStale && !record.isFresh(DateTime.now())) {
      return null;
    }

    final decoded = jsonDecode(record.payload);
    return decoded is Map<String, dynamic>
        ? decoded
        : Map<String, dynamic>.from(decoded as Map);
  }

  Future<List<Map<String, dynamic>>?> getJsonList(
    String key, {
    bool allowStale = false,
  }) async {
    final decoded = await getJson(key, allowStale: allowStale);
    if (decoded == null) {
      return null;
    }

    final items = decoded['items'];
    if (items is! List) {
      return null;
    }

    return items
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> remove(String key) async {
    await _box.delete(key);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  Future<void> clearPrefix(String prefix) async {
    final keys = _box.keys
        .whereType<String>()
        .where((key) => key.startsWith(prefix))
        .toList();
    for (final key in keys) {
      await _box.delete(key);
    }
  }

  Future<void> upsertInJsonList({
    required String key,
    required Map<String, dynamic> item,
    required String idField,
    Duration ttl = defaultTtl,
  }) async {
    final current =
        await getJsonList(key, allowStale: true) ?? <Map<String, dynamic>>[];
    final itemId = item[idField]?.toString();
    if (itemId == null || itemId.isEmpty) {
      return;
    }

    final updated = <Map<String, dynamic>>[];
    var inserted = false;
    for (final existing in current) {
      if (existing[idField]?.toString() == itemId) {
        updated.add(item);
        inserted = true;
      } else {
        updated.add(existing);
      }
    }
    if (!inserted) {
      updated.insert(0, item);
    }

    await putJsonList(key, updated, ttl: ttl);
  }

  Future<void> removeFromJsonList({
    required String key,
    required String itemId,
    required String idField,
    Duration ttl = defaultTtl,
  }) async {
    final current =
        await getJsonList(key, allowStale: true) ?? <Map<String, dynamic>>[];
    final updated = current
        .where((existing) => existing[idField]?.toString() != itemId)
        .toList();
    await putJsonList(key, updated, ttl: ttl);
  }

  Future<void> updateJsonListItem({
    required String key,
    required String itemId,
    required String idField,
    required Map<String, dynamic> Function(Map<String, dynamic> current)
    updater,
    Duration ttl = defaultTtl,
  }) async {
    final current =
        await getJsonList(key, allowStale: true) ?? <Map<String, dynamic>>[];
    final updated = current.map((existing) {
      if (existing[idField]?.toString() == itemId) {
        return updater(Map<String, dynamic>.from(existing));
      }
      return existing;
    }).toList();
    await putJsonList(key, updated, ttl: ttl);
  }

  Future<void> updateJsonListItemsByPrefix({
    required String prefix,
    required String itemId,
    required String idField,
    required Map<String, dynamic> Function(Map<String, dynamic> current)
    updater,
  }) async {
    final keys = _box.keys
        .whereType<String>()
        .where((key) => key.startsWith(prefix))
        .toList();
    for (final key in keys) {
      await updateJsonListItem(
        key: key,
        itemId: itemId,
        idField: idField,
        updater: updater,
      );
    }
  }

  Future<void> removeJsonListItemsByPrefix({
    required String prefix,
    required String itemId,
    required String idField,
  }) async {
    final keys = _box.keys
        .whereType<String>()
        .where((key) => key.startsWith(prefix))
        .toList();
    for (final key in keys) {
      await removeFromJsonList(key: key, itemId: itemId, idField: idField);
    }
  }
}
