sealed class HomeEvent {}

final class HomeEventUpdateState extends HomeEvent {}

final class HomeEventCreateSession extends HomeEvent {
  final String networkAddress;

  HomeEventCreateSession(this.networkAddress);
}

final class HomeEventJoinSession extends HomeEvent {
  final String joinKey;

  HomeEventJoinSession(this.joinKey);
}