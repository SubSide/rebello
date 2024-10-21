

abstract interface class SettingsRepository {
  Future<void> setUserName(String name);
  Stream<String> getUserName();
  Future<void> setDefaultNetworkAddress(String address);
  Stream<String> getDefaultNetworkAddress();
  Future<void> setListenWhileSpeaking(bool value);
  Stream<bool> getListenWhileSpeaking();
}