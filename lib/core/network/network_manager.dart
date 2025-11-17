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

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Public stream of connectivity states.
  Stream<bool> get connectionStream => _connectionController.stream;

  /// Initialize and start monitoring network connectivity.
  void initialize() {
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

      // Verify real connection (not just connected to router)
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Internal listener: updates connection status when connectivity changes.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final connected = !results.contains(ConnectivityResult.none);
    _connectionController.add(connected);
  }

  /// Throws a [NetworkException] if there is no active internet connection.
  Future<void> ensureConnected() async {
    if (!await isConnected) {
      throw NetworkException('No Internet Connection');
    }
  }
}
