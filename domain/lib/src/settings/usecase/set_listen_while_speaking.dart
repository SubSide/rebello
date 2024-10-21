import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetListenWhileSpeaking {
  final SettingsRepository _settingsRepository;

  SetListenWhileSpeaking(this._settingsRepository);

  Future<void> call(bool value) {
    return _settingsRepository.setListenWhileSpeaking(value);
  }
}