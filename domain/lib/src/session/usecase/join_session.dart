import 'package:injectable/injectable.dart';

import '../repository/session_repository.dart';

@injectable
class JoinSession {
  final SessionRepository _sessionRepository;

  JoinSession(this._sessionRepository);

  Future<void> call(String joinKey) {
    return _sessionRepository.joinSession(joinKey);
  }
}