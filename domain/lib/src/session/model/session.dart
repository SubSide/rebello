
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:domain/src/session/model/session_info.dart';
import 'package:domain/src/session/model/session_member.dart';

import 'session_state.dart';


abstract interface class Session {
    String? get sessionId;
    Stream<SessionInfo> info();
    Stream<List<SessionMember>> members();
    Stream<SessionState> state();
    Future<void> sendAudio(Uint8List data);
    Future<void> leave();
    Future<Result<String>> createInvitation();
}