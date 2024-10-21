import 'dart:convert';
import 'dart:developer';

import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:data/src/encryption/model/encrypted_message.dart';
import 'package:data/src/encryption/session_encryption.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';


class SignalSessionEncryption implements SessionEncryption {
  static var encryptionsCreated = 0;
  static var logOrder = 0;

  final Codec<String, String> _stringToBase64 = utf8.fuse(base64);

  final SenderKeyStore _keyStore = InMemorySenderKeyStore();
  late final GroupSessionBuilder _groupSessionBuilder = GroupSessionBuilder(_keyStore);
  late final SenderKeyName _groupSender;
  final encryptionNumber = encryptionsCreated++;

  SignalSessionEncryption(String groupUuid, String userUuid) {
    final address = SignalProtocolAddress(userUuid, 1);
    _groupSender = SenderKeyName(groupUuid, address);
    // We create an ingest key here, because under the hood it will also create a sender key for ourselves
    // I have found out that an own sender key is required to be able to send any encrypted messages
    createIngestKey();
  }

  @override
  Future<EncryptedMessage> encrypt(String message) async {
    final encrypted = await GroupCipher(_keyStore, _groupSender).encrypt(utf8.encode(_stringToBase64.encode(message)));
    return EncryptedMessage(_groupSender, encrypted);
  }

  @override
  Future<String> decrypt(EncryptedMessage message) async {
    final data = await GroupCipher(_keyStore, message.sender).decrypt(message.data);
    return _stringToBase64.decode(utf8.decode(data));
  }

  @override
  Future<IngestKey> createIngestKey() async {
    log('Creating ingest key');
    return IngestKey((await _groupSessionBuilder.create(_groupSender)).serialize(), _groupSender);
  }

  @override
  Future<void> ingestKey(IngestKey ingestKey) async {
    if (ingestKey.senderKeyName.sender.getName() == _groupSender.sender.getName()) {
      log('Skipping own ingest key');
      return;
    }

    log('Ingesting new key');
    await _groupSessionBuilder.process(ingestKey.senderKeyName, SenderKeyDistributionMessageWrapper.fromSerialized(ingestKey.key));
  }

  @override
  String get groupUuid => _groupSender.groupId;
}

/*
  Future<void> _test() async {
    log('Testing encryption');
    final groupUuid = const Uuid().v4();
    final session1 = SignalSessionEncryption(groupUuid, const Uuid().v4());
    final session2 = SignalSessionEncryption(session1.groupUuid, const Uuid().v4());
    // Note, calling session1.encrpypt will not work until we have called createIngestKey at least once on it
    final session1JoinKey = jsonEncode((await session1.createIngestKey()).toJson());
    final session2JoinKey = jsonEncode((await session2.createIngestKey()).toJson());
    session2.ingestKey(IngestKey.fromJson(jsonDecode(session1JoinKey)));
    session1.ingestKey(IngestKey.fromJson(jsonDecode(session2JoinKey)));

    const data = 'Hello, world!';
    final encrypted1 = await session1.encrypt(data);
    final encrypted2 = await session2.encrypt(data);
    final decrypted1 = await session2.decrypt(encrypted1);
    final decrypted2 = await session1.decrypt(encrypted2);

    log('Encrypted 1 -> 2: $encrypted1');
    log('Encrypted 2 -> 1: $encrypted2');
    log('Decrypted 1 -> 2: $decrypted1');
    log('Decrypted 2 -> 1: $decrypted2');
  }



  Future<void> workingEncryptionTest() async {
    final bobSenderAddress = SignalProtocolAddress('+00000000001', 1);
    final aliceSenderAddress = SignalProtocolAddress('+00000000002', 1);
    final bobGroupSender = SenderKeyName('Private group', bobSenderAddress);
    final aliceGroupSender = SenderKeyName('Private group', aliceSenderAddress);

    final aliceStore = InMemorySenderKeyStore();
    final bobStore = InMemorySenderKeyStore();

    final aliceSessionBuilder = GroupSessionBuilder(aliceStore);
    final bobSessionBuilder = GroupSessionBuilder(bobStore);

    final sentAliceDistributionMessage = await aliceSessionBuilder.create(aliceGroupSender);
    final receivedAliceDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentAliceDistributionMessage.serialize());
    bobSessionBuilder.process(aliceGroupSender, receivedAliceDistributionMessage);

    final sentBobDistributionMessage = await bobSessionBuilder.create(bobGroupSender);
    final receivedBobDistributionMessage = SenderKeyDistributionMessageWrapper.fromSerialized(sentBobDistributionMessage.serialize());
    aliceSessionBuilder.process(bobGroupSender, receivedBobDistributionMessage);

    final ciphertextFromAlice = await GroupCipher(aliceStore, aliceGroupSender).encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
    final plaintextFromAlice = await GroupCipher(bobStore, aliceGroupSender).decrypt(ciphertextFromAlice);
    log("Alice msg to Bob : ${plaintextFromAlice}");

    final ciphertextFromBob = await GroupCipher(bobStore, bobGroupSender).encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
    final plaintextFromBob = await GroupCipher(aliceStore, bobGroupSender).decrypt(ciphertextFromBob);
    log("Bob msg to Alice  : ${plaintextFromBob}");
  }
 */
