sealed class CallEvent {}

final class CallEventUpdateState extends CallEvent {}

final class CallEventLeave extends CallEvent {}

final class CallEventOpenQr extends CallEvent {}

final class CallEventCloseQr extends CallEvent {}

final class CallEventOpenMemberList extends CallEvent {}

sealed class CallBlocEvent {}

final class CallBlocEventOpenQr extends CallBlocEvent {
  final String groupUuid;
  final String groupName;
  final String data;

  CallBlocEventOpenQr(this.groupUuid, this.groupName, this.data);
}