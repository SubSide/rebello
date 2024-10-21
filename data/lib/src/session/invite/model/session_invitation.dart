import 'dart:convert';

import 'package:data/src/encryption/converter/rsa_public_key_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pointycastle/export.dart' as crypto;

part 'session_invitation.g.dart';

@JsonSerializable()
class SessionInvitation {
  final String inviteId;
  final String networkAddress;
  final String groupUuid;
  final String groupName;
  final String userUuid;
  final String confirmationCode;
  @RsaPublicKeyConverter()
  final crypto.RSAPublicKey userPublicRsaKey;

  const SessionInvitation(this.inviteId, this.networkAddress, this.groupUuid, this.groupName, this.userUuid, this.confirmationCode, this.userPublicRsaKey);

  factory SessionInvitation.fromJson(Map<String, dynamic> json) => _$SessionInvitationFromJson(json);

  factory SessionInvitation.fromEncodedString(String encodedString) => SessionInvitation.fromJson(jsonDecode(encodedString));

  Map<String, dynamic> toJson() => _$SessionInvitationToJson(this);

  String toEncodedString() => jsonEncode(toJson());
}