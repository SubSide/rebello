import 'package:json_annotation/json_annotation.dart';

part 'server_message.g.dart';
part 'server_message_types.dart';

@JsonSerializable()
class ServerMessage {
  final String source;
  final String target;
  final String info;
  final String data;

  ServerMessage(this.source, this.target, this.info, this.data);

  factory ServerMessage.fromJson(Map<String, dynamic> json) => _$ServerMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ServerMessageToJson(this);
}