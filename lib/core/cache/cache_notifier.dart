import 'dart:async';

class CacheNotifier {
  CacheNotifier._internal();
  static final CacheNotifier instance = CacheNotifier._internal();

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void notify(String key) {
    try {
      _controller.add(key);
    } catch (_) {}
  }

  void dispose() {
    _controller.close();
  }
}
