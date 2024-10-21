import 'ui_session_member.dart';

class UiSession {
  final String id;
  final String title;
  final List<UiSessionMember> members;
  final String state;

  const UiSession(this.id, this.title, this.members, this.state);
}