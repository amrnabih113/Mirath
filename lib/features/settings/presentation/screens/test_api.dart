import 'package:flutter/material.dart';
import 'package:mirath/features/settings/domain/repositories/setting_repository.dart';
import 'package:mirath/injection/injection_container.dart';

enum _TestStatus { running, success, failure }

class _ApiTestResult {
  final String title;
  _TestStatus status;
  String? message;
  int? durationMs;

  _ApiTestResult(this.title)
    : status = _TestStatus.running,
      message = null,
      durationMs = null;
}

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final List<_ApiTestResult> _results = [];
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    setState(() {
      _results.clear();
      _isRunning = true;
    });

    final repository = sl<SettingsRepository>();

    await _runOne('Active Sessions', () async {
      final result = await repository.getAllActiveSession();
      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) => ' first Sessions: ${data.first.createdAt}',
      );
    });

    await _runOne('Research Interests', () async {
      final result = await repository.getResearchInterests();
      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) => 'Interests Count: ${data.length}',
      );
    });

    await _runOne('Feed & AI Preferences', () async {
      final result = await repository.getFeedAndAiPreference();
      return result.fold(
        (failure) => throw Exception(failure.message),
        (data) =>
            'showRecommendedPapers: ${data.showRecommendedPapers}\n'
            'hideAlreadyReadPapers: ${data.hideAlreadyReadPapers}\n'
            'saveSearchHistory: ${data.saveSearchHistory}',
      );
    });

    setState(() => _isRunning = false);
  }

  Future<void> _runOne(String title, Future<String> Function() call) async {
    final result = _ApiTestResult(title);
    setState(() => _results.add(result));

    final stopwatch = Stopwatch()..start();
    try {
      final message = await call();
      stopwatch.stop();
      setState(() {
        result.status = _TestStatus.success;
        result.message = message;
        result.durationMs = stopwatch.elapsedMilliseconds;
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        result.status = _TestStatus.failure;
        result.message = e.toString().replaceFirst('Exception: ', '');
        result.durationMs = stopwatch.elapsedMilliseconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final successCount = _results
        .where((r) => r.status == _TestStatus.success)
        .length;
    final failureCount = _results
        .where((r) => r.status == _TestStatus.failure)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunning ? null : _runTests,
            tooltip: 'Re-run tests',
          ),
        ],
      ),
      body: Column(
        children: [
          _SummaryBar(
            total: _results.length,
            success: successCount,
            failure: failureCount,
            isRunning: _isRunning,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  _TestResultCard(result: _results[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  final int total;
  final int success;
  final int failure;
  final bool isRunning;

  const _SummaryBar({
    required this.total,
    required this.success,
    required this.failure,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          if (isRunning) ...[
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
            const Text('جاري التنفيذ...'),
          ] else
            Text(
              'النتيجة: $success نجح • $failure فشل • $total إجمالي',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

class _TestResultCard extends StatelessWidget {
  final _ApiTestResult result;

  const _TestResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    switch (result.status) {
      case _TestStatus.running:
        color = Colors.grey;
        icon = Icons.hourglass_empty;
        break;
      case _TestStatus.success:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case _TestStatus.failure:
        color = Colors.red;
        icon = Icons.cancel;
        break;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (result.durationMs != null)
                        Text(
                          '${result.durationMs}ms',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  if (result.message != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.message!,
                      style: TextStyle(color: color, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
