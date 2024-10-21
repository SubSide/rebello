import 'package:data/src/encryption/model/ingest_key.dart';
import 'package:data/src/session/invite/model/invite_acceptation.dart';
import 'package:data/src/session/invite/network/invite_request.dart';
import 'package:collection/collection.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:uuid/uuid.dart';

import '../model/session_invitation.dart';

class InviteStore {
  static const _inviteTtl = 5 * 60 * 1000; // 5 minutes

  final List<_Invite> _invites = [];

  Future<String> createInviteString(String userUuid, String groupUuid, String groupName, String networkAddress, RSAPublicKey userPublicKey) async {
    final inviteId = const Uuid().v4();
    final confirmationCode = const Uuid().v4();
    final invite = _Invite(inviteId, groupUuid, DateTime.now().add(const Duration(milliseconds: _inviteTtl)),
        confirmationCode);
    _invites.add(invite);
    return SessionInvitation(inviteId, networkAddress, groupUuid, groupName, userUuid, confirmationCode, userPublicKey).toEncodedString();
  }

  static Future<InviteRequest> createInviteRequest(SessionInvitation inviteRequest, IngestKey ingestKey, String userUuid, String username, RSAPublicKey userPublicRsaKey) async {
    final comparableCode = const Uuid().v4();
    final negotiationInfo = NegotiationInfo(inviteRequest.confirmationCode, userUuid, username, userPublicRsaKey, comparableCode, ingestKey);
    return InviteRequest(inviteRequest.inviteId, negotiationInfo);
  }

  Future<InviteAcceptation?> getInviteAcceptation(InviteRequest inviteRequest) async {
    final invite = _invites.firstWhereOrNull((element) => element.inviteId == inviteRequest.inviteId);
    if (invite == null) {
      return null;
    }
    if (invite.expiresAt.isBefore(DateTime.now())) {
      _invites.remove(invite);
      return null;
    }

    final negotiationInfo = inviteRequest.negotiationInfo;
    if (invite.confirmationCode != negotiationInfo.confirmationCode) {
      return null;
    }
    _invites.remove(invite);

    return InviteAcceptation(negotiationInfo.comparableCode, negotiationInfo.userUuid, negotiationInfo.username, invite.groupUuid, inviteRequest.negotiationInfo.userPublicKey, negotiationInfo.ingestKey);
  }
}


class _Invite {
  final String inviteId;
  final String groupUuid;
  final DateTime expiresAt;
  final String confirmationCode;

  _Invite(this.inviteId, this.groupUuid, this.expiresAt, this.confirmationCode);
}