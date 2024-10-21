import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:domain/settings.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:uuid/uuid.dart';

import '../../encryption/asymmetric_encryption.dart';
import '../../encryption/model/encrypted_message.dart';
import '../../encryption/signal_session_encryption.dart';
import '../../network/connection/network_connection.dart';
import '../../network/connection/socket_network_connection.dart';
import '../../network/model/message/abstract_direct_message.dart';
import '../../network/model/message/abstract_group_message.dart';
import '../../network/model/message/direct_message.dart';
import '../../network/model/message/group_message.dart';
import '../../network/model/server_message.dart';
import '../../network/network_handler.dart';
import '../handler/session_handler.dart';

class NetworkSession {
  final NetworkHandler networkHandler;
  final String networkAddress;
  final String userUuid = const Uuid().v4();
  String? groupUuid;
  late final NetworkConnection _networkConnection;
  late final AsymmetricEncryption directEncryption;
  SignalSessionEncryption? groupEncryption;
  late final StreamSubscription<ServerMessage> _messageSubscription;

  late final SessionHandler _sessionHandler;

  NetworkSession(this.networkHandler, this.networkAddress, GetUserName getUserName) {
    directEncryption = AsymmetricEncryption();
    _networkConnection = SocketNetworkConnection(networkAddress);
    _networkConnection.sendMessage(ServerMessageTypes.introduceToServer(userUuid));
    _messageSubscription =_networkConnection.messages.listen((message) {
      handleMessage(message);
    });
    _sessionHandler = SessionHandler(this, getUserName);
  }

  // TODO temporary until we find a better way to do this
  SessionHandler getHandler() => _sessionHandler;

  setGroupUuid(String groupUuid) {
    this.groupUuid = groupUuid;
    groupEncryption = SignalSessionEncryption(groupUuid, userUuid);
  }

  connectToGroup() {
    final uuid = groupUuid;
    if (uuid == null) {
      log('No group to connect to');
      return;
    }
    _networkConnection.sendMessage(ServerMessageTypes.subscribeMessage(userUuid, uuid));
  }

  handleMessage(ServerMessage message) async {
    if (message.target == ServerMessageTypes.serverTarget) {
      log('Received server message: ${message.data}');
      return;
    } else if (message.target == ServerMessageTypes.groupTarget) {
      final decryptedMessage = await groupEncryption?.decrypt(EncryptedMessage.fromJson(jsonDecode(message.data)));
      if (decryptedMessage == null) {
        log('Failed to decrypt group message');
        return;
      }
      final groupMessage = GroupMessage.fromJson(jsonDecode(decryptedMessage));
      _sessionHandler.handleGroupMessage(message.source, groupMessage);
      return;
    } else if (message.target == ServerMessageTypes.userTarget) {
      final decryptedMessage = await directEncryption.decrypt(message.data);
      final directMessage = DirectMessage.fromJson(jsonDecode(decryptedMessage));
      _sessionHandler.handleDirectMessage(message.source, directMessage);
      return;
    } else {
      log('Unknown message target: ${message.target}');
    }
  }

  sendGroupMessage(AbstractGroupMessage message) async {
    final groupEncr = groupEncryption;
    final encrypted = await groupEncryption?.encrypt(jsonEncode(message.toGroupMessage().toJson()));
    if (groupEncr == null || encrypted == null) {
      log('Failed to encrypt group message, not in a group');
      return;
    }
    final serverMessage = ServerMessageTypes.groupBroadcastMessage(userUuid, groupEncr.groupUuid, jsonEncode(encrypted.toJson()));
    _networkConnection.sendMessage(serverMessage);
  }

  sendDirectMessage(String recipientUuid, RSAPublicKey publicKey, AbstractDirectMessage message) async {
    final encrypted = await AsymmetricEncryption.encrypt(jsonEncode(message.toDirectMessage().toJson()), publicKey);
    final serverMessage = ServerMessageTypes.directMessage(userUuid, recipientUuid, encrypted);
    _networkConnection.sendMessage(serverMessage);
  }

  leave() {
    networkHandler.disconnect(this);
  }

  close() {
    _messageSubscription.cancel();
    _networkConnection.close();
  }
}