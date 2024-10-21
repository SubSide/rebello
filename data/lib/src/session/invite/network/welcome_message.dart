
import 'package:json_annotation/json_annotation.dart';

import '../../../network/model/message/abstract_direct_message.dart';

part 'welcome_message.g.dart';

@JsonSerializable()
class WelcomeMessage extends AbstractDirectMessage {
  static const String type = 'welcome';
  final String groupUuid;
  final String name;
  final String comparableCode;

  WelcomeMessage(this.groupUuid, this.name, this.comparableCode);

  @override
  String getType() => type;

  factory WelcomeMessage.fromJson(Map<String, dynamic> json) => _$WelcomeMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WelcomeMessageToJson(this);
}