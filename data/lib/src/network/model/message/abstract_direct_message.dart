import 'dart:convert';

import 'direct_message.dart';

abstract class AbstractDirectMessage {
  String getType();

  Map<String, dynamic> toJson();

  DirectMessage toDirectMessage() {
    return DirectMessage(getType(), jsonEncode(toJson()));
  }
}