// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/session.dart' as _i5;
import 'package:domain/settings.dart' as _i8;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:presentation/src/ui/app/bloc/app_bloc_factory.dart' as _i9;
import 'package:presentation/src/ui/pages/call/bloc/call_bloc_factory.dart'
    as _i6;
import 'package:presentation/src/ui/pages/call/qr/bloc/qr_share_bloc_factory.dart'
    as _i11;
import 'package:presentation/src/ui/pages/home/bloc/home_bloc_factory.dart'
    as _i7;
import 'package:presentation/src/ui/pages/home/mapper/state_mapper.dart' as _i3;
import 'package:presentation/src/ui/pages/scanner/bloc/scanner_bloc_factory.dart'
    as _i4;
import 'package:presentation/src/ui/pages/settings/bloc/settings_bloc_factory.dart'
    as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt $initModuleGetIt({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.StateMapper>(() => _i3.StateMapper());
    gh.factory<_i4.ScannerBlocFactory>(
        () => _i4.ScannerBlocFactory(gh<_i5.JoinSession>()));
    gh.factory<_i6.CallBlocFactory>(
        () => _i6.CallBlocFactory(gh<_i5.GetSessions>()));
    gh.factory<_i7.HomeBlocFactory>(() => _i7.HomeBlocFactory(
          gh<_i5.JoinSession>(),
          gh<_i5.CreateSession>(),
          gh<_i5.GetSessions>(),
          gh<_i8.GetDefaultNetworkAddress>(),
        ));
    gh.factory<_i9.AppBlocFactory>(
        () => _i9.AppBlocFactory(gh<_i5.GetAudio>()));
    gh.factory<_i10.SettingsBlocFactory>(() => _i10.SettingsBlocFactory(
          gh<_i8.GetUserName>(),
          gh<_i8.SetUserName>(),
          gh<_i8.GetDefaultNetworkAddress>(),
          gh<_i8.SetDefaultNetworkAddress>(),
          gh<_i8.GetListenWhileSpeaking>(),
          gh<_i8.SetListenWhileSpeaking>(),
        ));
    gh.factory<_i11.QrShareBlocFactory>(
        () => _i11.QrShareBlocFactory(gh<_i5.GetSessionEvents>()));
    return this;
  }
}
