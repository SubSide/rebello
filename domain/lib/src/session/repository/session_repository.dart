import 'dart:typed_data';

import 'package:async/async.dart';

import '../model/session.dart';
import '../model/session_event.dart';

abstract interface class SessionRepository {
  Future<void> joinSession(String joinKey);
  Future<Result<bool>> createSession(String networkAddress);
  Stream<List<Session>> sessions();
  Stream<SessionEvent> events();
  Stream<Uint8List> audio();
}