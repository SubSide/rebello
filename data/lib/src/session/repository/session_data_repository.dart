import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:data/src/network/network_handler.dart';
import 'package:data/src/session/handler/session_handler.dart';
import 'package:data/src/session/invite/model/session_invitation.dart';
import 'package:domain/session.dart';
import 'package:domain/settings.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

@LazySingleton(as: SessionRepository)
class SessionDataRepository implements SessionRepository {
  late final NetworkHandler _networkHandler;

  final StreamController<Uint8List> audioController = StreamController.broadcast();
  late final PublishConnectableStream<Uint8List> _audioStream =
  PublishConnectableStream(audioController.stream);

  final StreamController<SessionEvent> eventsController = StreamController.broadcast();
  late final PublishConnectableStream<SessionEvent> _eventStream =
  PublishConnectableStream(eventsController.stream);

  SessionDataRepository(GetUserName getUserName) {
    _networkHandler = NetworkHandler(this, getUserName);
    _audioStream.connect();
    _eventStream.connect();
  }

  @override
  Future<Result<bool>> createSession(String networkAddress) async {
    log('Creating session with address $networkAddress');
    final session = _networkHandler.connect(networkAddress);
    session.setGroupUuid(const Uuid().v4());
    session.connectToGroup();
    return Result.value(true);
  }

  audioReceived(Uint8List data) async {

    audioController.add(data);
  }

  @override
  Future<void> joinSession(String inviteString) async {
    log('Joining session with invite');
    final invitation = SessionInvitation.fromEncodedString(inviteString);
    log('Invitation: $invitation');
    final session = _networkHandler.connect(invitation.networkAddress);
    session.getHandler().requestJoinGroup(invitation);
  }

  @override
  Stream<List<Session>> sessions() => _networkHandler.sessionStream;

  @override
  Stream<Uint8List> audio() => _audioStream;

  @override
  Stream<SessionEvent> events() => _eventStream;
}
