
import 'package:data/src/network/model/server_message.dart';
import 'package:rxdart/streams.dart';

abstract interface class NetworkConnection {
  Stream<ServerMessage> get messages;
  Future<void> sendMessage(ServerMessage message);
  Future<void> close();
  ValueStream<NetworkConnectionStatus> get status;

  String get networkAddress;
}

enum NetworkConnectionStatus {
  connected,
  disconnected
}