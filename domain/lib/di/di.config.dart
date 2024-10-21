// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:domain/session.dart' as _i11;
import 'package:domain/src/session/repository/session_repository.dart' as _i13;
import 'package:domain/src/session/usecase/create_session.dart' as _i12;
import 'package:domain/src/session/usecase/get_audio.dart' as _i16;
import 'package:domain/src/session/usecase/get_session_events.dart' as _i10;
import 'package:domain/src/session/usecase/get_sessions.dart' as _i15;
import 'package:domain/src/session/usecase/join_session.dart' as _i14;
import 'package:domain/src/settings/repository/settings_repository.dart' as _i4;
import 'package:domain/src/settings/usecase/get_default_network_address.dart'
    as _i7;
import 'package:domain/src/settings/usecase/get_listen_while_speaking.dart'
    as _i8;
import 'package:domain/src/settings/usecase/get_user_name.dart' as _i9;
import 'package:domain/src/settings/usecase/set_default_network_address.dart'
    as _i6;
import 'package:domain/src/settings/usecase/set_listen_while_speaking.dart'
    as _i5;
import 'package:domain/src/settings/usecase/set_user_name.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

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
    gh.factory<_i3.SetUserName>(
        () => _i3.SetUserName(gh<_i4.SettingsRepository>()));
    gh.factory<_i5.SetListenWhileSpeaking>(
        () => _i5.SetListenWhileSpeaking(gh<_i4.SettingsRepository>()));
    gh.factory<_i6.SetDefaultNetworkAddress>(
        () => _i6.SetDefaultNetworkAddress(gh<_i4.SettingsRepository>()));
    gh.factory<_i7.GetDefaultNetworkAddress>(
        () => _i7.GetDefaultNetworkAddress(gh<_i4.SettingsRepository>()));
    gh.factory<_i8.GetListenWhileSpeaking>(
        () => _i8.GetListenWhileSpeaking(gh<_i4.SettingsRepository>()));
    gh.factory<_i9.GetUserName>(
        () => _i9.GetUserName(gh<_i4.SettingsRepository>()));
    gh.factory<_i10.GetSessionEvents>(
        () => _i10.GetSessionEvents(gh<_i11.SessionRepository>()));
    gh.factory<_i12.CreateSession>(
        () => _i12.CreateSession(gh<_i13.SessionRepository>()));
    gh.factory<_i14.JoinSession>(
        () => _i14.JoinSession(gh<_i13.SessionRepository>()));
    gh.factory<_i15.GetSessions>(
        () => _i15.GetSessions(gh<_i13.SessionRepository>()));
    gh.factory<_i16.GetAudio>(
        () => _i16.GetAudio(gh<_i13.SessionRepository>()));
    return this;
  }
}
