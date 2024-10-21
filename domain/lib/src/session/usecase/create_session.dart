

import 'package:async/async.dart';
import 'package:domain/src/session/repository/session_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateSession {
  final SessionRepository _sessionRepository;

  CreateSession(this._sessionRepository);

  Future<Result<bool>> call(String networkAddress) {
    return _sessionRepository.createSession(networkAddress);
  }
}