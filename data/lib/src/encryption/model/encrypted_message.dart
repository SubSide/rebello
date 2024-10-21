import 'dart:typed_data';

import 'package:data/src/encryption/converter/sender_key_name_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../../session/converter/uint8_list_converter.dart';

part 'encrypted_message.g.dart';

@JsonSerializable()
class EncryptedMessage {
  @SenderKeyNameConverter()
  final SenderKeyName sender;
  @Uint8ListConverter()
  final Uint8List data;

  EncryptedMessage(this.sender, this.data);

  factory EncryptedMessage.fromJson(Map<String, dynamic> json) => _$EncryptedMessageFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptedMessageToJson(this);
}