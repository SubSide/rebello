import 'dart:async';

import 'package:domain/session.dart';
import 'package:presentation/src/ui/component/session/ui_session_member.dart';
import 'package:rxdart/rxdart.dart';

import '../ui_session.dart';
import '../ui_session_member_mapper.dart';

class UiSessionMapper {
  final StreamController<UiSession> _controller = StreamController.broadcast();
  late final ValueConnectableStream<UiSession> _stream = ValueConnectableStream(_controller.stream);

  final UiSessionMemberMapper _uiSessionMemberMapper;

  String? _id;
  String? _title;
  List<UiSessionMember>? _members;
  String? _state;

  StreamSubscription? _titleSubscription;
  StreamSubscription? _membersSubscription;
  StreamSubscription? _stateSubscription;
  late StreamSubscription _sessionSubscription;
  late StreamSubscription _listenerSubscription;

  UiSessionMapper(this._uiSessionMemberMapper) {
    _sessionSubscription = _stream.connect();
    _listenerSubscription = _stream.listen((value) {});
  }

  set(Session session) {
    print('UiSessionMapper: set $session');
    _id = session.sessionId;

    _titleSubscription?.cancel();
    _membersSubscription?.cancel();
    _stateSubscription?.cancel();

    _titleSubscription = session.info().listen((info) {
      print('UiSessionMapper: set title ${info.title}');
      if (_title == info.title) return;
      _title = info.title;
      _setState();
    });
    _membersSubscription = session.members().listen((members) {
      print('UiSessionMapper: set members ${members.length}');
      // TODO check if members are changed
      _members = members.map((member) => _uiSessionMemberMapper.map(member)).toList();
      _setState();
    });
    _stateSubscription = session.state().listen((state) {
      print('UiSessionMapper: set state $state');
      if (_state == state.toString()) return;
      // TODO
      _state = state.toString();
      _setState();
    });
  }

  _setState() {
    print('UiSessionMapper: _setState $_id $_title $_members $_state');
    _controller.add(UiSession(_id ?? '', _title ?? 'Loading...', _members ?? [], _state ?? 'Loading'));
  }

  Stream<UiSession> get stream => _stream;

  void dispose() {
    _controller.close();
    _titleSubscription?.cancel();
    _membersSubscription?.cancel();
    _stateSubscription?.cancel();
    _sessionSubscription.cancel();
    _listenerSubscription.cancel();
  }
}