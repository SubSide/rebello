import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../repository/session_repository.dart';

@injectable
class GetAudio {
  final SessionRepository _sessionRepository;

  GetAudio(this._sessionRepository);

  Stream<Uint8List> call() {
    return _sessionRepository.audio();
  }
}