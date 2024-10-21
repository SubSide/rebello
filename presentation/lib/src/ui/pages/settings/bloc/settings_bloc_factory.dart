import 'package:domain/settings.dart';
import 'package:injectable/injectable.dart';

import 'settings_bloc.dart';

@injectable
class SettingsBlocFactory {
  final GetUserName _getUserName;
  final SetUserName _setUserName;
  final GetDefaultNetworkAddress _getDefaultNetworkAddress;
  final SetDefaultNetworkAddress _setDefaultNetworkAddress;
  final GetListenWhileSpeaking _getListenWhileSpeaking;
  final SetListenWhileSpeaking _setListenWhileSpeaking;

  SettingsBlocFactory(this._getUserName, this._setUserName, this._getDefaultNetworkAddress, this._setDefaultNetworkAddress, this._getListenWhileSpeaking, this._setListenWhileSpeaking);

  SettingsBloc create() {
    return SettingsBloc(_getUserName, _setUserName, _getDefaultNetworkAddress, _setDefaultNetworkAddress, _getListenWhileSpeaking, _setListenWhileSpeaking);
  }
}