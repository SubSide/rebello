
import 'dart:convert';

import 'package:pointycastle/export.dart' as crypto;

import 'package:json_annotation/json_annotation.dart';

class RsaPublicKeyConverter implements JsonConverter<crypto.RSAPublicKey, String> {
  const RsaPublicKeyConverter();

  @override
  crypto.RSAPublicKey fromJson(String data) {
    final json = jsonDecode(data);
    return crypto.RSAPublicKey(BigInt.parse(json['modulus']), BigInt.parse(json['exponent']));
  }

  @override
  String toJson(crypto.RSAPublicKey object) {
    return jsonEncode({'modulus': object.modulus.toString(), 'exponent': object.exponent.toString()});
  }

}