part of 'server_message.dart';

extension ServerMessageTypes on ServerMessage {
  static const String serverTarget = 'server';
  static const String groupTarget = 'group';
  static const String userTarget = 'user';

  static const String _serverSubscribe = 'subscribe';
  static const String _serverUnsubscribe = 'unsubscribe';
  static const String _serverIntroduce = 'introduce';

  static subscribeMessage(String sourceUuid, String topic) => ServerMessage(sourceUuid, serverTarget, _serverSubscribe, topic);

  static unsubscribeMessage(String sourceUuid, String topic) => ServerMessage(sourceUuid, serverTarget, _serverUnsubscribe, topic);

  static introduceToServer(String userUuid) => ServerMessage(userUuid, serverTarget, _serverIntroduce, userUuid);

  static groupBroadcastMessage(String sourceUuid, String groupUuid, String data) => ServerMessage(sourceUuid, groupTarget, groupUuid, data);

  static directMessage(String sourceUuid, String userUuid, String data) => ServerMessage(sourceUuid, userTarget, userUuid, data);
}