import 'package:domain/session.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class StateMapper {
  String map(SessionState state) {
    switch (state) {
      case SessionState.connected:
        return 'Connected';
      case SessionState.connecting:
        return 'Connecting';
      case SessionState.disconnected:
        return 'Disconnected';
      case SessionState.invitePending:
        return 'Invite Pending';
      default:
        throw Exception('Unknown state: $state');
    }
  }
}