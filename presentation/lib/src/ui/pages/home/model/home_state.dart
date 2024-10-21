
import 'package:presentation/src/ui/component/session/ui_session.dart';

sealed class HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateIdle extends HomeState {
  final Stream<List<UiSession>> sessions;
  final String defaultNetworkAddress;

  HomeStateIdle(this.sessions, this.defaultNetworkAddress);
}