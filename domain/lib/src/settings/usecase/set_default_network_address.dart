import 'package:domain/src/settings/repository/settings_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetDefaultNetworkAddress {
  final SettingsRepository _settingsRepository;

  SetDefaultNetworkAddress(this._settingsRepository);

  Future<void> call(String networkAddress) {
    return _settingsRepository.setDefaultNetworkAddress(networkAddress);
  }
}