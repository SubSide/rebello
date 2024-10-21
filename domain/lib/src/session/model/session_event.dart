sealed class SessionEvent {}

class InviteConfirmation extends SessionEvent {
  final String groupUuid;
  final String username;
  final String comparableCode;
  final Function onAccept;

  InviteConfirmation(this.groupUuid, this.username, this.comparableCode, this.onAccept);
}