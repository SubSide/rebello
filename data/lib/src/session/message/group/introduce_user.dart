import 'package:data/src/encryption/converter/rsa_public_key_converter.dart';
import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pointycastle/export.dart';

import '../../../network/model/message/abstract_group_message.dart';

part 'introduce_user.g.dart';

@JsonSerializable()
class IntroduceUser extends AbstractGroupMessage {
  static const String type = 'introduce_user';

  final String userUuid;
  final String username;
  @RsaPublicKeyConverter()
  final RSAPublicKey userPublicKey;
  final IngestKey ingestKey;

  IntroduceUser(this.userUuid, this.username, this.userPublicKey, this.ingestKey);

  @override
  String getType() => type;

  factory IntroduceUser.fromJson(Map<String, dynamic> json) => _$IntroduceUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IntroduceUserToJson(this);
}