sealed class SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final String username;
  final String defaultNetworkAddress;
  final bool listenWhileSpeaking;

  SettingsLoaded(this.username, this.defaultNetworkAddress, this.listenWhileSpeaking);
}