import 'package:flutter/material.dart';
import 'my_app_bar.dart';
import '../../cache/hive_cache_service.dart';

class PendingQueueViewer extends StatefulWidget {
  final HiveCacheService cacheService;
  const PendingQueueViewer({super.key, required this.cacheService});

  @override
  State<PendingQueueViewer> createState() => _PendingQueueViewerState();
}

class _PendingQueueViewerState extends State<PendingQueueViewer> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw =
        await widget.cacheService.getJsonList(
          'retry:queue',
          allowStale: true,
        ) ??
        [];
    setState(() {
      _items = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: const Text('Pending Queue')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, i) {
            final item = _items[i];
            return ListTile(
              title: Text(item['type'] ?? 'unknown'),
              subtitle: Text(item['payload']?.toString() ?? ''),
            );
          },
        ),
      ),
    );
  }
}
