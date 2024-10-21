
import 'package:domain/session.dart';

sealed class CallState {}

class CallStateLoading extends CallState {}

class CallStateSuccess extends CallState {
  final Session session;
  final String name;
  final List<SessionMember> members;
  final List<SessionMember> speakers;

  CallStateSuccess({ required this.session, required this.name, required this.members, required this.speakers});
}
