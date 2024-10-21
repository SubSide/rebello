import 'dart:async';

import 'package:domain/session.dart';
import 'package:domain/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/src/ui/pages/home/model/home_event.dart';
import 'package:presentation/src/ui/pages/home/model/home_state.dart';

import '../../../component/session/mapper/ui_session_list_mapper.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CreateSession _createSession;
  final JoinSession _joinSession;
  final GetSessions _getSessions;
  final GetDefaultNetworkAddress _getDefaultNetworkAddress;

  final UiSessionListMapper _uiSessionListMapper = UiSessionListMapper();
  String _defaultNetworkAddress = '';
  final List<StreamSubscription> _subscriptions = [];

  HomeBloc(this._createSession, this._joinSession, this._getSessions, this._getDefaultNetworkAddress) : super(HomeStateLoading()) {
    on<HomeEventCreateSession>((event, emit) => _createSession(event.networkAddress));
    on<HomeEventJoinSession>((event, emit) => _joinSession(event.joinKey));
    on<HomeEventUpdateState>((event, emit) => _updateState(emit));

    _subscriptions.add(_getDefaultNetworkAddress().listen((defaultNetworkAddress) {
      _defaultNetworkAddress = defaultNetworkAddress;
      add(HomeEventUpdateState());
    }));

    _subscriptions.add(_getSessions().listen((sessions) {
      _uiSessionListMapper.set(sessions);
    }));

    add(HomeEventUpdateState());
  }

  _updateState(Emitter<HomeState> emit) {
    emit(HomeStateIdle(_uiSessionListMapper.stream, _defaultNetworkAddress));
  }

  @override
  Future<void> close() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    return super.close();
  }
}
