
part of 'session_handler.dart';

extension SessionHandlerNetwork on SessionHandler {

  handleGroupMessage(String sourceUuid, GroupMessage message) {
    log('Received group message: ${message.type}');
    final json = jsonDecode(message.data);

    switch(message.type) {
      case IntroduceUser.type:
        final introduceUser = IntroduceUser.fromJson(json);
        log('Received introduceUser: ${introduceUser.userUuid}');
        _someoneIntroducedSomeoneNew(introduceUser);
        break;
      case AudioMessage.type:
        final audioMessage = AudioMessage.fromJson(json);
        log('Received audioMessage');
        _onAudioReceived(sourceUuid, audioMessage);
        break;
      case UpdateUserName.type:
        final updateUserName = UpdateUserName.fromJson(json);
        log('Received updateUserName');
        _someoneChangedTheirName(sourceUuid, updateUserName);
      case SayHelloToGroup.type:
        final sayHelloToGroup = SayHelloToGroup.fromJson(json);
        log('Received sayHelloToGroup');
        _someoneSaysHiToGroup(sourceUuid, sayHelloToGroup);
        break;
      default:
        log('Unknown group message type: ${message.type}');
    }
  }


  handleDirectMessage(String sourceUuid, DirectMessage message) {
    log('Received direct message: ${message.type}');
    final json = jsonDecode(message.data);

    switch(message.type) {
      case IntroduceSelf.type:
        final introduceSelf = IntroduceSelf.fromJson(json);
        log('Received introduceSelf');
        _someoneSaysHiToYou(introduceSelf);
        break;
      case InviteRequest.type:
        final inviteRequest = InviteRequest.fromJson(json);
        log('Received inviteRequest');
        handleInviteRequestMessage(inviteRequest);
        break;
      case WelcomeMessage.type:
        final welcomeMessage = WelcomeMessage.fromJson(json);
        log('Received welcomeMessage');
        receiveGroupWelcomeMessage(welcomeMessage);
        break;
      default:
        log('Unknown direct message type: ${message.type}');
    }
  }

  _sendDirectMessage(String targetUuid, RSAPublicKey publicKey, AbstractDirectMessage message) {
    _network.sendDirectMessage(targetUuid, publicKey, message);
  }

  _sendGroupMessage(AbstractGroupMessage message) {
    _network.sendGroupMessage(message);
  }
}