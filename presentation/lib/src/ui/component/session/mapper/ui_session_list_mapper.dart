import 'dart:async';
import 'dart:collection';

import 'package:domain/session.dart';
import 'package:presentation/src/ui/component/session/mapper/ui_session_mapper.dart';
import 'package:presentation/src/ui/component/session/ui_session_member_mapper.dart';
import 'package:rxdart/rxdart.dart';

import '../ui_session.dart';

class UiSessionListMapper {

  final Map<Session, _UiSessionItem> _sessionMap = HashMap();
  List<Session> _sortedSessions = [];

  final StreamController<List<UiSession>> _controller = StreamController.broadcast();
  late final ValueConnectableStream<List<UiSession>> _stream = ValueConnectableStream(_controller.stream);

  final List<StreamSubscription> _subscriptions = [];

  UiSessionListMapper() {
    _subscriptions.add(_stream.connect());
    _subscriptions.add(_stream.listen((value) {}));
  }


  set(List<Session> sessions) {
    print("UiSessionListMapper: set ${sessions.length}");
    _sortedSessions = sessions;
    // Add new sessions
    for (final session in sessions) {
      if (!_sessionMap.containsKey(session)) {
        _sessionMap[session] = _UiSessionItem(session, onItemChanged);
      }
    }

    // Remove old sessions
    for (final session in _sessionMap.keys.toList()) {
      if (!sessions.contains(session)) {
        _sessionMap.remove(session)?.dispose();
      }
    }

    print("UiSessionListMapper done: set ${_sessionMap.length}");

    onItemChanged();
  }

  Stream<List<UiSession>> get stream => _stream;

  onItemChanged() {
    final uiSessions = _sortedSessions.map((session) => _sessionMap[session]?.uiSession).nonNulls.toList();
    print("UiSessionListMapper: onItemChanged $uiSessions");
    _controller.add(uiSessions);
  }

  void dispose() {
    for (var element in _sessionMap.values) {
      element.dispose();
    }
    for (var element in _subscriptions) {
      element.cancel();
    }
    _controller.close();
  }
}


class _UiSessionItem {
  final UiSessionMapper _uiSessionMapper = UiSessionMapper(UiSessionMemberMapper());
  UiSession? uiSession;
  StreamSubscription? _subscription;

  _UiSessionItem(Session session, void Function() onItemChanged) {
    print("_UiSessionItem: _UiSessionItem $session");
    _subscription = _uiSessionMapper.stream.listen((uiSession) {
      print("_UiSessionItem: _uiSessionMapper.stream.listen $uiSession");
      this.uiSession = uiSession;
      onItemChanged();
    });
    _uiSessionMapper.set(session);
  }

  void dispose() {
    _uiSessionMapper.dispose();
    _subscription?.cancel();
  }
}