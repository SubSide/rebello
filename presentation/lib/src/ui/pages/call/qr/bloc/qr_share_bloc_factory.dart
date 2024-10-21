
import 'package:domain/session.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/src/ui/pages/call/qr/bloc/qr_share_bloc.dart';

@injectable
class QrShareBlocFactory {
  final GetSessionEvents _sessionEvents;

  QrShareBlocFactory(this._sessionEvents);

  QrShareBloc create(String groupUuid) {
    return QrShareBloc(_sessionEvents, groupUuid);
  }
}