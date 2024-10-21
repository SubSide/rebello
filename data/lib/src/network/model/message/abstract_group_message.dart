import 'dart:convert';

import 'group_message.dart';

abstract class AbstractGroupMessage {
  String getType();

  Map<String, dynamic> toJson();

  GroupMessage toGroupMessage() {
    return GroupMessage(getType(), jsonEncode(toJson()));
  }
}