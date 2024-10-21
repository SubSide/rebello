import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDefaultNetworkAddress {
  final SettingsRepository _settingsRepository;

  GetDefaultNetworkAddress(this._settingsRepository);

  Stream<String> call() {
    return _settingsRepository.getDefaultNetworkAddress();
  }
}