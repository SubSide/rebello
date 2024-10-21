sealed class SettingsEvent {}

class SettingsUpdateState extends SettingsEvent {}

class SettingsEventSetUserName extends SettingsEvent {
  final String username;

  SettingsEventSetUserName(this.username);
}

class SettingsEventSetDefaultNetworkAddress extends SettingsEvent {
  final String address;

  SettingsEventSetDefaultNetworkAddress(this.address);
}

class SettingsEventSetListenWhileSpeaking extends SettingsEvent {
  final bool value;

  SettingsEventSetListenWhileSpeaking(this.value);
}