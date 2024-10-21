sealed class QrShareEvent {}

class QrShareIncomingInviteRequest extends QrShareEvent {
  final String username;
  final String comparableCode;

  QrShareIncomingInviteRequest(this.username, this.comparableCode);
}

class QrShareEventAcceptedInvite extends QrShareEvent {
  final bool accepted;

  QrShareEventAcceptedInvite(this.accepted);
}