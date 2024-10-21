
import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

class EncryptedConverter implements JsonConverter<Encrypted, String> {
  const EncryptedConverter();

  @override
  Encrypted fromJson(String data) {
    return Encrypted.fromBase64(data);
  }

  @override
  String toJson(Encrypted object) {
    return object.base64;
  }
}