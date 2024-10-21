import 'package:domain/src/session/model/session.dart';
import 'package:injectable/injectable.dart';

import '../repository/session_repository.dart';

@injectable
class GetSessions {
  final SessionRepository _sessionRepository;

  GetSessions(this._sessionRepository);

  Stream<List<Session>> call() {
    return _sessionRepository.sessions();
  }
}