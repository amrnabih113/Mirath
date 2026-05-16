import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../error/exceptions.dart';

class NetworkManager {
  // Singleton
  static final NetworkManager instance = NetworkManager._internal();
  factory NetworkManager() => instance;
  NetworkManager._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  bool _currentConnectionStatus = true;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Public stream of connectivity states.
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get currentConnectionStatus => _currentConnectionStatus;

  /// Initialize and start monitoring network connectivity.
  Future<void> initialize() async {
    _currentConnectionStatus = await isConnected;
    _connectionController.add(_currentConnectionStatus);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Cancel listeners and free resources.
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionController.close();
  }

  /// Checks if the device has *real* Internet access.
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none)) return false;

      // Verify real connection by trying multiple DNS lookups
      // Some networks may block certain domains
      final domains = ['google.com', 'cloudflare.com', '1.1.1.1'];
      for (final domain in domains) {
        try {
          final lookup = await InternetAddress.lookup(
            domain,
          ).timeout(const Duration(seconds: 2));
          if (lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty) {
            return true;
          }
        } catch (_) {
          // Try next domain
          continue;
        }
      }
      // If all lookups failed, fall back to connectivity result
      // (device might be behind a restrictive firewall but still have internet)
      return !results.contains(ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  /// Internal listener: updates connection status when connectivity changes.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final connected = !results.contains(ConnectivityResult.none);
    _currentConnectionStatus = connected;
    _connectionController.add(connected);
  }

  /// Throws a [NetworkException] if there is no active internet connection.
  Future<void> ensureConnected() async {
    if (!await isConnected) {
      throw NetworkException('No Internet Connection');
    }
  }
}
