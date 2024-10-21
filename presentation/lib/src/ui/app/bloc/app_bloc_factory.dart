
import 'package:domain/session.dart';
import 'package:injectable/injectable.dart';
import 'package:presentation/src/ui/app/bloc/app_bloc.dart';

@injectable
class AppBlocFactory {
  final GetAudio _getAudio;

  AppBlocFactory(this._getAudio);

  AppBloc create() {
    return AppBloc(_getAudio);
  }
}