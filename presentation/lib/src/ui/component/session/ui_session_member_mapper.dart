import 'package:domain/session.dart';
import 'package:presentation/src/ui/component/session/ui_session_member.dart';

class UiSessionMemberMapper {
  UiSessionMember map(SessionMember sessionMember) {
    return UiSessionMember(sessionMember.uuid, sessionMember.name);
  }
}