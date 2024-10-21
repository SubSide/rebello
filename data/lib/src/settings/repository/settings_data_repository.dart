import 'dart:async';

import 'package:domain/settings.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: SettingsRepository)
class SettingsDataRepository implements SettingsRepository {
  static const _defaultUserName = 'Rebel';
  static const _defaultNetworkAddress = '';
  static const _defaultListenWhileSpeaking = false;

  static const _keyUserName = 'shared_prefs_user_name';
  static const _keyListenWhileSpeaking = 'shared_prefs_listen_while_speaking';
  static const _keyDefaultNetworkAddress = 'shared_prefs_default_network_address';

  final prefs = SharedPreferences.getInstance();

  final StreamController<String> _usernameController = StreamController.broadcast();
  late final ValueConnectableStream<String> _usernameStream = ValueConnectableStream(_usernameController.stream);

  final StreamController<bool> _listenWhileSpeakingController = StreamController.broadcast();
  late final ValueConnectableStream<bool> _listenWhileSpeakingStream = ValueConnectableStream(_listenWhileSpeakingController.stream);

  final StreamController<String> _defaultNetworkAddressController = StreamController.broadcast();
  late final ValueConnectableStream<String> _defaultNetworkAddressStream = ValueConnectableStream(_defaultNetworkAddressController.stream);

  final List<StreamSubscription> _subscriptions = [];

  SettingsDataRepository() {
    _subscriptions.add(_usernameStream.connect());
    _subscriptions.add(_usernameStream.listen(((name) => {})));
    _subscriptions.add(_listenWhileSpeakingStream.connect());
    _subscriptions.add(_listenWhileSpeakingStream.listen((value) => {}));
    _subscriptions.add(_defaultNetworkAddressStream.connect());
    _subscriptions.add(_defaultNetworkAddressStream.listen((address) => {}));


    prefs.then((prefs) {
      final username = prefs.getString(_keyUserName) ?? _defaultUserName;
      _usernameController.add(username);

      final listenWhileSpeaking = prefs.getBool(_keyListenWhileSpeaking) ?? _defaultListenWhileSpeaking;
      _listenWhileSpeakingController.add(listenWhileSpeaking);

      final defaultNetworkAddress = prefs.getString(_keyDefaultNetworkAddress) ?? _defaultNetworkAddress;
      _defaultNetworkAddressController.add(defaultNetworkAddress);
    });
  }


  @override
  Stream<String> getUserName() {
    return _usernameStream;
  }

  @override
  Future<void> setUserName(String name) {
    _usernameController.add(name);
    return prefs.then((prefs) => prefs.setString(_keyUserName, name));
  }

  @override
  Stream<bool> getListenWhileSpeaking() {
    return _listenWhileSpeakingStream;
  }


  @override
  Future<void> setListenWhileSpeaking(bool value) {
    _listenWhileSpeakingController.add(value);
    return prefs.then((prefs) => prefs.setBool(_keyListenWhileSpeaking, value));
  }

  @override
  Stream<String> getDefaultNetworkAddress() {
    return _defaultNetworkAddressStream;
  }

  @override
  Future<void> setDefaultNetworkAddress(String address) {
    _defaultNetworkAddressController.add(address);
    return prefs.then((prefs) => prefs.setString(_keyDefaultNetworkAddress, address));
  }

  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _usernameController.close();
    _listenWhileSpeakingController.close();
    _defaultNetworkAddressController.close();
  }
}