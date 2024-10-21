
import 'package:json_annotation/json_annotation.dart';

part 'direct_message.g.dart';

@JsonSerializable()
class DirectMessage {
  final String type;
  final String data;

  DirectMessage(this.type, this.data);

  factory DirectMessage.fromJson(Map<String, dynamic> json) => _$DirectMessageFromJson(json);

  Map<String, dynamic> toJson() => _$DirectMessageToJson(this);
}