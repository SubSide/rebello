
import 'package:domain/session.dart';
import 'package:domain/settings.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/src/ui/pages/home/bloc/home_bloc.dart';

@injectable
class HomeBlocFactory {
  final JoinSession _joinSession;
  final CreateSession _createSession;
  final GetSessions _getSessions;
  final GetDefaultNetworkAddress _getDefaultNetworkAddress;

  HomeBlocFactory(this._joinSession, this._createSession, this._getSessions, this._getDefaultNetworkAddress);

  HomeBloc create() {
    return HomeBloc(_createSession, _joinSession, _getSessions, _getDefaultNetworkAddress);
  }
}