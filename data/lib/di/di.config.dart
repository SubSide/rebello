// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/src/network/network_handler.dart' as _i600;
import 'package:data/src/session/repository/session_data_repository.dart'
    as _i11;
import 'package:data/src/settings/repository/settings_data_repository.dart'
    as _i338;
import 'package:domain/session.dart' as _i345;
import 'package:domain/settings.dart' as _i174;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $initModuleGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i600.NetworkHandler>(() => _i600.NetworkHandler(
          gh<_i11.SessionDataRepository>(),
          gh<_i174.GetUserName>(),
        ));
    gh.lazySingleton<_i345.SessionRepository>(
        () => _i11.SessionDataRepository(gh<_i174.GetUserName>()));
    gh.lazySingleton<_i174.SettingsRepository>(
        () => _i338.SettingsDataRepository());
    return this;
  }
}
