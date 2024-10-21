import 'package:injectable/injectable.dart';

import '../../../session.dart';

@injectable
class GetSessionEvents {
  final SessionRepository _sessionRepository;

  GetSessionEvents(this._sessionRepository);

  Stream<SessionEvent> call() {
    return _sessionRepository.events();
  }
}