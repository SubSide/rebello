
import 'package:data/src/encryption/converter/rsa_public_key_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pointycastle/export.dart';

import '../../../encryption/model/ingest_key.dart';
import '../../../network/model/message/abstract_direct_message.dart';

part 'invite_request.g.dart';

@JsonSerializable()
class InviteRequest extends AbstractDirectMessage {
  static const type = 'invite_request';

  final String inviteId;
  final NegotiationInfo negotiationInfo;

  InviteRequest(this.inviteId, this.negotiationInfo);

  @override
  getType() => type;

  factory InviteRequest.fromJson(Map<String, dynamic> json) => _$InviteRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InviteRequestToJson(this);
}

@JsonSerializable()
class NegotiationInfo {
  final String confirmationCode;
  final String userUuid;
  final String username;
  @RsaPublicKeyConverter()
  final RSAPublicKey userPublicKey;
  final String comparableCode;
  final IngestKey ingestKey;

  NegotiationInfo(this.confirmationCode, this.userUuid, this.username, this.userPublicKey, this.comparableCode, this.ingestKey);

  factory NegotiationInfo.fromJson(Map<String, dynamic> json) => _$NegotiationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$NegotiationInfoToJson(this);
}