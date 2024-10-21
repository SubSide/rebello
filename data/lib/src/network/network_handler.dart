
import 'dart:async';

import 'package:data/src/session/repository/session_data_repository.dart';
import 'package:domain/session.dart';
import 'package:domain/settings.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

import '../session/model/network_session.dart';

@LazySingleton()
class NetworkHandler {
  final SessionDataRepository sessionDataRepository;
  final GetUserName _getUserName;
  final List<NetworkSession> _sessions = [];

  // Temporarily moved here
  final StreamController<List<Session>> _sessionStreamController = StreamController.broadcast();
  late final ValueConnectableStream<List<Session>> _sessionStream =
  ValueConnectableStream<List<Session>>(_sessionStreamController.stream);
  bool _isBackgroundExecutionInitialized = false;

  NetworkHandler(this.sessionDataRepository, this._getUserName) {
    _sessionStream.connect();
    _sessionStream.listen((data) {});
  }

  getSessions() => _sessions;

  get sessionStream => _sessionStream;

  _initializeBackgroundExecution() async {
    await FlutterBackground.hasPermissions;
    await Permission.notification.request();
    const androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: 'Rebello',
        notificationText: 'Rebello is running in the background',
        notificationImportance: AndroidNotificationImportance.Default
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
    FlutterBackground.enableBackgroundExecution();
  }

  NetworkSession connect(String networkAddress) {
    if (!_isBackgroundExecutionInitialized) {
      _isBackgroundExecutionInitialized = true;
      _initializeBackgroundExecution();
    }

    print('Connecting to $networkAddress');
    final session = NetworkSession(this, networkAddress, _getUserName);
    _sessions.add(session);
    _sessionStreamController.add(_sessions.map((e) => e.getHandler().getSession()).toList());

    return session;
  }

  disconnect(NetworkSession session) {
    print('Disconnecting from ${session.networkAddress}');
    _sessions.remove(session);
    session.close();
    _sessionStreamController.add(_sessions.map((e) => e.getHandler().getSession()).toList());

    if (_sessions.isEmpty) {
      FlutterBackground.enableBackgroundExecution();
    }
  }
}

