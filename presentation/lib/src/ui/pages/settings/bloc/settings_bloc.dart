import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/src/ui/pages/settings/model/settings_event.dart';
import 'package:presentation/src/ui/pages/settings/model/settings_state.dart';
import 'package:domain/settings.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetUserName _getUserName;
  final SetUserName _setUserName;
  final GetDefaultNetworkAddress _getDefaultNetworkAddress;
  final SetDefaultNetworkAddress _setDefaultNetworkAddress;
  final GetListenWhileSpeaking _getListenWhileSpeaking;
  final SetListenWhileSpeaking _setListenWhileSpeaking;

  String? _username;
  String? _defaultNetworkAddress;
  bool? _listenWhileSpeaking;
  final List<StreamSubscription> _subscriptions = [];

  SettingsBloc(this._getUserName, this._setUserName, this._getDefaultNetworkAddress, this._setDefaultNetworkAddress, this._getListenWhileSpeaking, this._setListenWhileSpeaking) : super(SettingsLoading()) {
    on<SettingsEventSetUserName>((event, emit) => _setUserName(event.username));
    on<SettingsEventSetDefaultNetworkAddress>((event, emit) => _setDefaultNetworkAddress(event.address));
    on<SettingsEventSetListenWhileSpeaking>((event, emit) => _setListenWhileSpeaking(event.value));
    on<SettingsUpdateState>((event, emit) => _updateState(emit));

    _subscriptions.add(_getUserName().listen((username) {
      _username = username;
      add(SettingsUpdateState());
    }));
    _subscriptions.add(_getDefaultNetworkAddress().listen((defaultNetworkAddress) {
      _defaultNetworkAddress = defaultNetworkAddress;
      add(SettingsUpdateState());
    }));
    _subscriptions.add(_getListenWhileSpeaking().listen((listenWhileSpeaking) {
      _listenWhileSpeaking = listenWhileSpeaking;
      add(SettingsUpdateState());
    }));
  }

  void _updateState(Emitter<SettingsState> emit) {
    final state = SettingsLoaded(_username ?? '???', _defaultNetworkAddress ?? '???', _listenWhileSpeaking ?? false);
    print('SettingsBloc: updating state: $state');
    emit(state);
  }

  @override
  Future<void> close() {
    for (var element in _subscriptions) {
      element.cancel();
    }
    return super.close();
  }
}
