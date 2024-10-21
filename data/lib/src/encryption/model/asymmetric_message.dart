

import 'package:data/src/encryption/converter/encrypted_converter.dart';
import 'package:data/src/encryption/converter/iv_converter.dart';
import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asymmetric_message.g.dart';

@JsonSerializable()
class AsymmetricMessage {
  final String encryptedAesKey;
  @EncryptedConverter()
  final Encrypted encryptedAesMessage;
  @IvConverter()
  final IV aesIv;

  AsymmetricMessage(this.encryptedAesKey, this.encryptedAesMessage, this.aesIv);


  factory AsymmetricMessage.fromJson(Map<String, dynamic> json) => _$AsymmetricMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AsymmetricMessageToJson(this);
}
