import 'package:domain/session.dart';

sealed class AppEvent {}

final class AppEventStartRecording extends AppEvent {
  final Session session;

  AppEventStartRecording(this.session);
}

final class AppEventStopRecording extends AppEvent {}