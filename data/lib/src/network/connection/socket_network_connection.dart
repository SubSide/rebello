
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:rxdart/streams.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../model/server_message.dart';
import 'network_connection.dart';

class SocketNetworkConnection implements NetworkConnection {
  @override
  final String networkAddress;
  late final WebSocketChannel channel;
  late final StreamController<ServerMessage> _messageController = StreamController.broadcast();
  late final PublishConnectableStream<ServerMessage> _messageStream = PublishConnectableStream(_messageController.stream);
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  final _statusController = StreamController<NetworkConnectionStatus>.broadcast();
  late final ValueConnectableStream<NetworkConnectionStatus> _status = ValueConnectableStream(_statusController.stream);

  SocketNetworkConnection(this.networkAddress) {
    _statusController.add(NetworkConnectionStatus.connected);
    channel = WebSocketChannel.connect(Uri.parse(networkAddress));
    _subscriptions.add(_messageStream.connect());
    _subscriptions.add(_status.connect());

    _subscriptions.add(channel.stream.listen(_receiveMessage, onDone: () {
      _statusController.add(NetworkConnectionStatus.disconnected);
      close();
    }));
  }

  _receiveMessage(dynamic message) {
    log('New message received');
    _messageController.add(ServerMessage.fromJson(jsonDecode(message)));
  }

  @override
  Future<void> sendMessage(ServerMessage message) async {
    return channel.sink.add(jsonEncode(message.toJson()));
  }

  @override
  Stream<ServerMessage> get messages => _messageStream;

  @override
  ValueStream<NetworkConnectionStatus> get status => _status;

  @override
  Future<void> close() async {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    channel.sink.close();
  }
}