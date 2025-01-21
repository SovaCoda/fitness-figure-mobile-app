import 'dart:async';
import 'package:ffapp/components/button_themes.dart';
import 'package:ffapp/components/ff_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../components/ff_app_button.dart';

class ConnectivityService {
  // Singleton instance
  static final ConnectivityService _instance = ConnectivityService._internal();
  Logger logger = Logger();

  // Factory constructor
  factory ConnectivityService() {
    return _instance;
  }

  // Private constructor
  ConnectivityService._internal() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  ConnectivityResult? _currentConnectivity = ConnectivityResult.none;

  // Getter for the current connectivity state
  ConnectivityResult? get currentConnectivity => _currentConnectivity;

  // Navigator key to display popups for bad connection state
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Initialize the service
  void _init() {
    // Set the initial connectivity state
    _checkInitialConnectivity();

    // Start listening to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _currentConnectivity = results.first;
        _handleConnectivityChange(results.first);
      }
    });
  }

  // Check the initial connectivity state
  Future<void> _checkInitialConnectivity() async {
    try {
      List<ConnectivityResult>? connectivityResults =
          await _connectivity.checkConnectivity();
      if (connectivityResults.isNotEmpty) {
        _currentConnectivity = connectivityResults.first;
      }
    } catch (e) {
      logger.e('Error checking connectivity: $e');
    }
  }

  // Handle connectivity changes
  void _handleConnectivityChange(ConnectivityResult result) async {
    await Future.delayed(Duration
        .zero); // Some platforms need a delay for context to load before connection changes
    final context = navigatorKey.currentState?.overlay?.context;

    if (context != null && context.mounted) {
      switch (result) {
        case ConnectivityResult.none: // No Connection Send User to Sign In
          _showOfflinePopUp(context);
          break;
        case ConnectivityResult.mobile: // Do something for mobile
          break;
        case ConnectivityResult.wifi: // Do something for wifi
          break;
        default:
          break;
      }
    }
  }

  void _showOfflinePopUp(BuildContext context) {
    showFFDialogWithChildren(
        "Offline",
        [
          const Text(
              'It looks like youre offline, connect to the internet and reload!')
        ],
        false,
        FFAppButton(
            text: "Okay!",
            onPressed: () => {context.goNamed("SignIn")},
            size: MediaQuery.sizeOf(context).width * 0.6,
            height: MediaQuery.sizeOf(context).height * 0.08),
        context);
  }

  // Dispose the subscription
  void dispose() {
    _subscription?.cancel();
  }
}
