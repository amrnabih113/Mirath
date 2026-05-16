import 'package:hive/hive.dart';

class CacheRecord {
  final String key;
  final String payload;
  final DateTime cachedAt;
  final int ttlSeconds;

  const CacheRecord({
    required this.key,
    required this.payload,
    required this.cachedAt,
    required this.ttlSeconds,
  });

  bool isFresh(DateTime now) {
    if (ttlSeconds <= 0) {
      return true;
    }

    final expiry = cachedAt.add(Duration(seconds: ttlSeconds));
    return now.isBefore(expiry);
  }
}

class CacheRecordAdapter extends TypeAdapter<CacheRecord> {
  @override
  final int typeId = 29;

  @override
  CacheRecord read(BinaryReader reader) {
    final values = reader.readMap();
    return CacheRecord(
      key: values['key'] as String? ?? '',
      payload: values['payload'] as String? ?? '',
      cachedAt: DateTime.parse(
        values['cachedAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
      ttlSeconds: values['ttlSeconds'] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, CacheRecord obj) {
    writer.writeMap({
      'key': obj.key,
      'payload': obj.payload,
      'cachedAt': obj.cachedAt.toIso8601String(),
      'ttlSeconds': obj.ttlSeconds,
    });
  }
}
