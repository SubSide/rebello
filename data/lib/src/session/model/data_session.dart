import 'dart:async';
import 'dart:typed_data';
import 'package:async/async.dart';

import 'package:domain/session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

class DataSession implements Session {
  static const _defaultSessionName = 'New session';

  final StreamController<List<SessionMember>> _membersController = StreamController.broadcast();
  late final ValueConnectableStream<List<SessionMember>> _membersStream =
    ValueConnectableStream(_membersController.stream);

  final StreamController<SessionInfo> _infoController = StreamController.broadcast();
  late final ValueConnectableStream<SessionInfo> _infoStream =
    ValueConnectableStream(_infoController.stream);

  final StreamController<SessionState> _stateController = StreamController.broadcast();
  late final ValueConnectableStream<SessionState> _stateStream =
    ValueConnectableStream(_stateController.stream);

  // subscriptions
  final List<StreamSubscription<Object>> _subscriptions = [];
  final DataSessionInterface _interface;

  // Session data
  String name = _defaultSessionName;

  DataSession(this._interface) {
    _subscriptions.add(_membersStream.connect());
    _subscriptions.add(_membersStream.listen((val) => {}));
    _subscriptions.add(_infoStream.connect());
    _subscriptions.add(_infoStream.listen((val) => {}));
    _subscriptions.add(_stateStream.connect());
    _subscriptions.add(_stateStream.listen((val) => {}));

    setSessionName(_defaultSessionName);
    setMembers([]);
    setSessionState(SessionState.connecting);
  }

  setSessionName(String name) {
    this.name = name;
    _infoController.add(SessionInfo(name, _interface.getSelfUuid()));
  }

  setMembers(List<SessionMember> members) {
    _membersController.add(members);
  }

  setSessionState(SessionState state) {
    _stateController.add(state);
  }

  @override
  Stream<SessionInfo> info() => _infoStream;

  @override
  Stream<List<SessionMember>> members() => _membersStream;

  @override
  Stream<SessionState> state() => _stateStream;

  @override
  Future<void> sendAudio(Uint8List data) async => _interface.sendAudio(data);

  @override
  Future<Result<String>> createInvitation() => _interface.createInvitation();

  @override
  Future<void> leave() => _interface.leave();

  @override
  String? get sessionId => _interface.getGroupUuid();

  Future<void> close() async {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _membersController.close();
    _infoController.close();
    _stateController.close();
  }
}


abstract interface class DataSessionInterface {
  String? getGroupUuid();
  String getSelfUuid();
  Future<void> sendAudio(Uint8List data);
  Future<Result<String>> createInvitation();
  Future<void> leave();
}