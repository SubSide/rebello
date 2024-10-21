import 'dart:async';

import 'package:domain/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/qr_share_events.dart';
import '../model/qr_share_state.dart';

class QrShareBloc extends Bloc<QrShareEvent, QrShareState> {
  final GetSessionEvents _sessionEvents;
  StreamSubscription<dynamic>? _eventSubscription;
  Function? _onAcceptInvite;

  QrShareBloc(this._sessionEvents, String groupUuid) : super(QrShareState(null)) {
    on<QrShareEventAcceptedInvite>(_onAcceptedInvite);
    on<QrShareIncomingInviteRequest>(_onIncomingInviteRequest);

    _eventSubscription = _sessionEvents().listen((event) {
      if (event is InviteConfirmation && event.groupUuid == groupUuid) {
        _onAcceptInvite = event.onAccept;
        add(QrShareIncomingInviteRequest(event.username, event.comparableCode));
      }
    });
  }

  void _onIncomingInviteRequest(QrShareIncomingInviteRequest event, Emitter<QrShareState> emit) {
    emit(QrShareState(IncomingInvitationRequest(event.username, event.comparableCode)));
  }

  void _onAcceptedInvite(QrShareEventAcceptedInvite event, Emitter<QrShareState> emit) {
    if (event.accepted) {
      _onAcceptInvite?.call();
    }
    emit(QrShareState(null));
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
