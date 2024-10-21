import 'package:json_annotation/json_annotation.dart';

import '../../../network/model/message/abstract_group_message.dart';

part 'say_hello_to_group.g.dart';

@JsonSerializable()
class SayHelloToGroup extends AbstractGroupMessage {
  static const String type = 'say_hello_to_group';

  final String username;

  SayHelloToGroup(this.username);

  @override
  String getType() => type;

  factory SayHelloToGroup.fromJson(Map<String, dynamic> json) => _$SayHelloToGroupFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SayHelloToGroupToJson(this);
}