
import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

class IvConverter implements JsonConverter<IV, String> {
  const IvConverter();

  @override
  IV fromJson(String data) {
    return IV.fromBase64(data);
  }

  @override
  String toJson(IV object) {
    return object.base64;
  }
}