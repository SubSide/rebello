import 'dart:async';
import 'dart:collection';

import 'package:domain/session.dart';
import 'package:rxdart/rxdart.dart';

class MembersController {
  final StreamController<List<SessionMember>> _controller = StreamController.broadcast();
  late final ValueConnectableStream<List<SessionMember>> _stream = ValueConnectableStream(_controller.stream);

  final Map<String, _SessionMember> _members = HashMap();

  MembersController() {
    _stream.connect();
  }

  addMember(String uuid, String name) {
    _members[uuid] = _SessionMember(_updateState, uuid: uuid, name: name);
  }

  removeMember(String uuid) {
    _members.remove(uuid);
    _updateState();
  }

  updateMemberName(String uuid, String name) {
    _members[uuid]?.updateName(name);
  }

  receivedSpeaking(String uuid) {
    _members[uuid]?.receivedSpeaking();
  }

  _updateState() {
    _controller.add(_members.values.map((e) => e.member).toList());
  }

  Stream<List<SessionMember>> get stream => _stream;
}



class _SessionMember {
  String uuid;
  String name;
  bool isSpeaking = false;
  final Function() _updateState;
  Timer? _speakingTimer;
  late SessionMember member;

  _SessionMember(this._updateState, {required this.uuid, required this.name}) {
    member = SessionMember(uuid: uuid, name: name, isSpeaking: isSpeaking);
  }

  updateName(String name) {
    this.name = name;
    _selfUpdate();
  }

  receivedSpeaking() {
    // cancel previous timer
    _speakingTimer?.cancel();

    // create new timer, this resets the speaking state
    _speakingTimer = Timer(const Duration(seconds: 1), () {
      isSpeaking = false;
      _selfUpdate();
    });

    if (!isSpeaking) {
      isSpeaking = true;
      _selfUpdate();
    }
  }

  _selfUpdate() {
    member = SessionMember(uuid: uuid, name: name, isSpeaking: isSpeaking);
    _updateState();
  }
}