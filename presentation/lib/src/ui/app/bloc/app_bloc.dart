import 'dart:async';

import 'package:domain/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/src/ui/app/model/app_event.dart';
import 'package:sound_stream/sound_stream.dart';

import '../model/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final _playerStream = PlayerStream();
  final _recorderStream = RecorderStream();
  Session? _session;

  AppBloc(GetAudio getAudio) : super(AppStateIdle()) {
    on<AppEventStartRecording>((event, emit) => _startRecording(event.session));
    on<AppEventStopRecording>((event, emit) => _stopRecording());

    _recorderStream.initialize();
    _recorderStream.audioStream.listen((data) {
      _session?.sendAudio(data);
    });
    _playerStream.initialize();
    _playerStream.start();
  }


  _startRecording(Session session) {
    _session = session;
    _recorderStream.start();
  }

  _stopRecording() {
    _recorderStream.stop();
  }


  @override
  Future<void> close() async {
    _playerStream.dispose();
    _recorderStream.dispose();
    return super.close();
  }
}
