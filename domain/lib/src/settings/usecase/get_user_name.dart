import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserName {
  final SettingsRepository _settingsRepository;

  GetUserName(this._settingsRepository);

  Stream<String> call() {
    return _settingsRepository.getUserName();
  }
}