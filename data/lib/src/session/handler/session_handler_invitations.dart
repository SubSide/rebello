part of 'session_handler.dart';

extension SessionHandlerInvitations on SessionHandler {
  Future<Result<void>> requestJoinGroup(SessionInvitation invite) async {
    log('Requesting to join group of ${invite.userUuid}');
    _network.setGroupUuid(invite.groupUuid);
    final ingestKey = await _network.groupEncryption?.createIngestKey();
    if (ingestKey == null) {
      log('Failed to create ingest key');
      return Result.error('Failed to create ingest key, we are not in a group');
    }

    final request = await InviteStore.createInviteRequest(invite, ingestKey, _network.userUuid, await _getUserName().first, _network.directEncryption.publicKey);
    _sendDirectMessage(invite.userUuid, invite.userPublicRsaKey, request);
    return Result.value(null);
  }

  Future<void> handleInviteRequestMessage(InviteRequest inviteRequest) async {
    log('Checking if we actually made an invite for ${inviteRequest.inviteId}');
    final acceptation = await _inviteStore.getInviteAcceptation(inviteRequest);
    final groupEncryption = _network.groupEncryption;
    if (acceptation == null || groupEncryption == null) return;

    log('We did! Creating confirmation message for front-end');
    final confirm = InviteConfirmation(acceptation.groupUuid, acceptation.username, acceptation.comparableCode, () async {
      await groupEncryption.ingestKey(inviteRequest.negotiationInfo.ingestKey);
      _sendDirectMessage(acceptation.userUuid, acceptation.userPublicKey, WelcomeMessage(acceptation.groupUuid, await _getUserName().first, acceptation.comparableCode));
      _sendDirectMessage(acceptation.userUuid, acceptation.userPublicKey, IntroduceSelf(await groupEncryption.createIngestKey()));
      _sendGroupMessage(IntroduceUser(acceptation.userUuid, acceptation.username, inviteRequest.negotiationInfo.userPublicKey, acceptation.ingestKey));
    });

    log('Putting confirmation message in event stream');
    _network.networkHandler.sessionDataRepository.eventsController.add(confirm);
  }

  Future<void> receiveGroupWelcomeMessage(WelcomeMessage welcomeMessage) async {
    if (welcomeMessage.groupUuid != _network.groupUuid) {
      log('Received welcome message for group we are not trying to join');
      return;
    }
    _network.connectToGroup();
    _sendGroupMessage(SayHelloToGroup(await _getUserName().first));
  }

  _someoneIntroducedSomeoneNew(IntroduceUser message) async {
    final groupEncryption = _network.groupEncryption;
    if (groupEncryption == null) {
      log('We are not in a group, cannot introduce new user');
      return;
    }
    groupEncryption.ingestKey(message.ingestKey);
    _sendDirectMessage(message.userUuid, message.userPublicKey, IntroduceSelf(await groupEncryption.createIngestKey()));
    _membersController.addMember(message.userUuid, message.username);
  }

  _someoneSaysHiToYou(IntroduceSelf message) {
    _network.groupEncryption?.ingestKey(message.ingestKey);
  }
}