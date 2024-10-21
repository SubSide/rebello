import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:data/src/network/model/message/abstract_direct_message.dart';
import 'package:data/src/session/invite/network/welcome_message.dart';
import 'package:data/src/session/message/group/audio_message.dart';
import 'package:data/src/session/message/group/say_hello_to_group.dart';
import 'package:domain/session.dart';
import 'package:domain/settings.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../network/model/message/abstract_group_message.dart';
import '../../network/model/message/direct_message.dart';
import '../../network/model/message/group_message.dart';
import '../invite/model/session_invitation.dart';
import '../invite/network/invite_request.dart';
import '../invite/store/invite_store.dart';
import '../message/direct/introduce_self.dart';
import '../message/group/introduce_user.dart';
import '../message/group/update_user_name.dart';
import '../model/data_session.dart';
import '../model/network_session.dart';
import 'controller/members_controller.dart';

part 'session_handler_invitations.dart';
part 'session_handler_network.dart';
part 'session_handler_logic.dart';

class SessionHandler implements DataSessionInterface {
  final InviteStore _inviteStore = InviteStore();
  late final DataSession _session;
  final NetworkSession _network;
  final MembersController _membersController = MembersController();
  final List<StreamSubscription> _subscriptions = [];
  final GetUserName _getUserName;

  SessionHandler(this._network, this._getUserName) {
    _session = DataSession(this);

    _subscriptions.add(_membersController.stream.listen(_session.setMembers));
    _subscriptions.add(_getUserName().listen(_onOwnNameChanged));
  }

  @override
  Future<void> sendAudio(Uint8List audioData) async {
    final message = AudioMessage(audioData);
    _sendGroupMessage(message);
    _membersController.receivedSpeaking(_network.userUuid);
  }

  @override
  Future<Result<String>> createInvitation() async {
    final groupUuid = _network.groupUuid;
    if (groupUuid == null) {
      return Result.error('No group to create invitation for');
    }

    final invitation = await _inviteStore.createInviteString(_network.userUuid, groupUuid, _session.name, _network.networkAddress, _network.directEncryption.publicKey);
    return Result.value(invitation);
  }

  // TODO find better way
  DataSession getSession() {
    return _session;
  }

  @override
  Future<void> leave() async {
    _network.leave();
  }

  @override
  String? getGroupUuid() {
    return _network.groupUuid;
  }

  @override
  String getSelfUuid() {
    return _network.userUuid;
  }

  Future<void> close() async {
    _session.close();

    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  Future<void> sendEvent(SessionEvent event) async {
    _network.networkHandler.sessionDataRepository.eventsController.add(event);
  }
}
