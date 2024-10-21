import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetListenWhileSpeaking {
  final SettingsRepository _settingsRepository;

  GetListenWhileSpeaking(this._settingsRepository);

  Stream<bool> call() {
    return _settingsRepository.getListenWhileSpeaking();
  }
}