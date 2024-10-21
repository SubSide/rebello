
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import '../../session/converter/uint8_list_converter.dart';
import '../converter/sender_key_name_converter.dart';

part 'ingest_key.g.dart';

@JsonSerializable()
class IngestKey {
  @Uint8ListConverter()
  final Uint8List key;
  @SenderKeyNameConverter()
  final SenderKeyName senderKeyName;

  IngestKey(this.key, this.senderKeyName);

  factory IngestKey.fromJson(Map<String, dynamic> json) => _$IngestKeyFromJson(json);

  Map<String, dynamic> toJson() => _$IngestKeyToJson(this);
}