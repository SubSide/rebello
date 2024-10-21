
import 'package:domain/session.dart';
import 'package:injectable/injectable.dart';

import 'call_bloc.dart';

@injectable
class CallBlocFactory {
  final GetSessions _getCurrentSession;

  CallBlocFactory(this._getCurrentSession);

  CallBloc create(String groupUuid) {
    return CallBloc(_getCurrentSession, groupUuid);
  }
}