import 'package:json_annotation/json_annotation.dart';

import '../../../network/model/message/abstract_group_message.dart';

part 'update_user_name.g.dart';

@JsonSerializable()
class UpdateUserName extends AbstractGroupMessage {
  static const String type = 'update_user_name';

  final String username;

  UpdateUserName(this.username);

  @override
  String getType() => type;

  factory UpdateUserName.fromJson(Map<String, dynamic> json) => _$UpdateUserNameFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UpdateUserNameToJson(this);
}