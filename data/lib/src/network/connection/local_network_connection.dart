import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../model/server_message.dart';
import 'network_connection.dart';

class LocalNetworkConnection implements NetworkConnection {
  final StreamController<ServerMessage> _networkStreamController = StreamController.broadcast();
  late final PublishConnectableStream<ServerMessage> _networkStream =
      PublishConnectableStream<ServerMessage>(_networkStreamController.stream);

  final ValueConnectableStream<NetworkConnectionStatus> source = ValueConnectableStream<NetworkConnectionStatus>(Stream.value(NetworkConnectionStatus.connected));

  LocalNetworkConnection() {
    _networkStream.connect();
  }

  @override
  Stream<ServerMessage> get messages => _networkStream;

  @override
  ValueStream<NetworkConnectionStatus> get status => source;

  @override
  Future<void> sendMessage(ServerMessage message) async {
    _networkStreamController.add(message);
  }

  @override
  String get networkAddress => 'localhost';

  @override
  Future<void> close() async {
    await _networkStreamController.close();
  }
}
