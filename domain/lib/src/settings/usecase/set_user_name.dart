import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetUserName {
  final SettingsRepository _settingsRepository;

  SetUserName(this._settingsRepository);

  Future<void> call(String username) {
    return _settingsRepository.setUserName(username);
  }
}