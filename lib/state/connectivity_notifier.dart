import 'dart:async';
import 'package:flutter/material.dart';

class ConnectivityNotifier extends ChangeNotifier {
  /*final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  List<ConnectivityResult> get connectionStatus => _connectionStatus;
  bool get isConnected =>
      _connectionStatus.any((r) => r != ConnectivityResult.none);

  ConnectivityNotifier() {
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final status = await _connectivity.checkConnectivity();
      _updateStatus(status);
    } catch (_) {
      _updateStatus([ConnectivityResult.none]);
    }
  }

  void _updateStatus(List<ConnectivityResult> result) {
    _connectionStatus = result;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }*/
}
