import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypt;
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart";

import 'model/asymmetric_message.dart';


class AsymmetricEncryption {
  late final AsymmetricKeyPair _keyPair;

  AsymmetricEncryption() {
    final generator = RSAKeyGenerator();
    final secureRandom = SecureRandom('Fortuna')
      ..seed(KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    generator.init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), secureRandom));
    _keyPair = generator.generateKeyPair();
  }

  RSAPublicKey get publicKey => _keyPair.publicKey as RSAPublicKey;

  Future<String> decrypt(String rawMessage) async {
    final encryptedMessage = AsymmetricMessage.fromJson(jsonDecode(rawMessage));
    final crypt.Encrypter rsaDecrypter = crypt.Encrypter(crypt.RSA(privateKey: _keyPair.privateKey as RSAPrivateKey));
    final aesKey = rsaDecrypter.decrypt(crypt.Encrypted.fromBase64(encryptedMessage.encryptedAesKey));
    final aesDecrypter = crypt.Encrypter(crypt.AES(crypt.Key.fromBase64(aesKey)));
    final message = aesDecrypter.decrypt(encryptedMessage.encryptedAesMessage, iv: encryptedMessage.aesIv);
    return message;
  }

  static Future<String> encrypt(String message, RSAPublicKey publicKey) async {
    final crypt.Encrypter encrypter = crypt.Encrypter(crypt.RSA(publicKey: publicKey));
    final aesKey = crypt.Key.fromSecureRandom(32);
    final crypt.IV aesIv = crypt.IV.fromSecureRandom(16);

    final aesEncrypter = crypt.Encrypter(crypt.AES(aesKey));
    final encryptedMessage = aesEncrypter.encrypt(message, iv: aesIv);
    final encryptedAesKey = encrypter.encrypt(aesKey.base64);
    final asymmetricMessage = AsymmetricMessage(encryptedAesKey.base64, encryptedMessage, aesIv);
    return jsonEncode(asymmetricMessage.toJson());
  }
}