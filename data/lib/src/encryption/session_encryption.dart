
import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:data/src/encryption/model/encrypted_message.dart';

abstract interface class SessionEncryption {

  Future<EncryptedMessage> encrypt(String data);

  Future<String> decrypt(EncryptedMessage message);

  Future<IngestKey> createIngestKey();

  Future<void> ingestKey(IngestKey ingestKey);

  String get groupUuid;
}