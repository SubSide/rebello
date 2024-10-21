
import 'package:domain/session.dart';
import 'package:injectable/injectable.dart';

import 'scanner_bloc.dart';

@injectable
class ScannerBlocFactory {
  final JoinSession _joinSession;

  ScannerBlocFactory(this._joinSession);

  ScannerBloc create() {
    return ScannerBloc(_joinSession);
  }
}