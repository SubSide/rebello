import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:domain/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/src/ui/pages/call/model/call_events.dart';
import 'package:presentation/src/ui/pages/call/model/call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final GetSessions _getSessions;

  String _sessionName = '';
  List<SessionMember> _sessionMembers = [];

  final StreamController<CallBlocEvent> _eventController = StreamController.broadcast();
  late final events = _eventController.stream;

  late final StreamSubscription<dynamic> sessionSubscription;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  final String _groupUuid;
  Session? _session;

  CallBloc(this._getSessions, this._groupUuid) : super(CallStateLoading()) {
    on<CallEventUpdateState>((event, emit) => _updateState(emit));
    on<CallEventOpenQr>(_openQr);
    on<CallEventLeave>(_leave);

    sessionSubscription = _getSessions().listen((sessions) {
      _clearSubscriptions();
      final session = sessions.firstWhereOrNull((session) => session.sessionId == _groupUuid);
      _session = session;
      // TODO close session if not found
      if (session == null) return;

      _subscriptions.add(session.info().listen((info) {
        _sessionName = info.title;
        log("Session name: ${info.title}");
        add(CallEventUpdateState());
      }));
      _subscriptions.add(session.members().listen((members) {
        _sessionMembers = members;
        log("Session members: ${members.length}");
        add(CallEventUpdateState());
      }));
    });

    add(CallEventUpdateState());
  }

  void _openQr(CallEventOpenQr event, emit) async {
    log("Opening QR...");
    final data = await _session?.createInvitation();
    if (data == null || data.isError) return;
    _eventController.add(CallBlocEventOpenQr(_groupUuid, _sessionName, data.asValue!.value));
    _updateState(emit);
  }

  void _leave(CallEventLeave event, emit) {
    _session?.leave();
  }

  void _updateState(emit) {
    final session = _session;
    if (session == null) return;

    emit(CallStateSuccess(
        session: session,
        name: _sessionName,
        members: _sessionMembers,
        speakers: _sessionMembers.where((member) => member.isSpeaking).toList()));
  }

  @override
  Future<void> close() async {
    sessionSubscription.cancel();
    _clearSubscriptions();
    return super.close();
  }

  void _clearSubscriptions() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
}
