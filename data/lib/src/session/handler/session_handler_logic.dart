

part of 'session_handler.dart';

extension SessionHandlerLogic on SessionHandler {
  _onAudioReceived(String sourceUuid, AudioMessage message) {
    _network.networkHandler.sessionDataRepository.audioController.add(message.audioData);
    _membersController.receivedSpeaking(sourceUuid);
  }

  _onOwnNameChanged(String name) {
    _sendGroupMessage(UpdateUserName(name));
  }

  _someoneChangedTheirName(String sourceUuid, UpdateUserName message) {
    _membersController.updateMemberName(sourceUuid, message.username);
  }

  _someoneSaysHiToGroup(String sourceUuid, SayHelloToGroup message) {
    _membersController.updateMemberName(sourceUuid, message.username);
  }
}