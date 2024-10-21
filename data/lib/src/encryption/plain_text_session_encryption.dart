import 'dart:convert';
import 'dart:typed_data';

import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:data/src/encryption/session_encryption.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

import 'model/encrypted_message.dart';

class PlainTextSessionEncryption implements SessionEncryption {

  @override
  Future<EncryptedMessage> encrypt(String data) async {
    return EncryptedMessage(const SenderKeyName('', SignalProtocolAddress('', 1)), utf8.encode(data));
  }

  @override
  Future<String> decrypt(EncryptedMessage message) async {
    return utf8.decode(message.data);
  }

  @override
  Future<IngestKey> createIngestKey() async {
    return IngestKey(Uint8List.fromList([]), const SenderKeyName('', SignalProtocolAddress('', 1)));
  }

  @override
  Future<void> ingestKey(IngestKey ingestKey) async {
    // NO-OP
  }

  @override
  String get groupUuid => 'local';
}