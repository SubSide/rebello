import 'package:json_annotation/json_annotation.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

class SenderKeyNameConverter implements JsonConverter<SenderKeyName, String> {
  const SenderKeyNameConverter();

  @override
  SenderKeyName fromJson(String json) {
    final parts = json.split('::');
    return SenderKeyName(parts[0], SignalProtocolAddress(parts[1], int.parse(parts[2])));
  }

  @override
  String toJson(SenderKeyName object) {
    return object.serialize();
  }

}