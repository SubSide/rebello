class QrShareState {
  final IncomingInvitationRequest? incomingInvitationRequest;

  QrShareState(this.incomingInvitationRequest);
}

class IncomingInvitationRequest {
  final String username;
  final String comparableCode;

  IncomingInvitationRequest(this.username, this.comparableCode);
}