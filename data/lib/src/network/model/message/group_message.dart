import 'package:json_annotation/json_annotation.dart';

part 'group_message.g.dart';

@JsonSerializable()
class GroupMessage {
  final String type;
  final String data;

  GroupMessage(this.type, this.data);

  factory GroupMessage.fromJson(Map<String, dynamic> json) => _$GroupMessageFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMessageToJson(this);
}
