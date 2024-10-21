import 'dart:developer';

import 'package:domain/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/scanner_event.dart';
import '../model/scanner_state.dart';


class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final JoinSession _joinSession;

  ScannerBloc(this._joinSession) : super(ScannerStateLoading()) {
    on<ScannerEventUpdateState>((event, emit) => _updateState(event, emit));
    on<ScannerEventScanBarcode>((event, emit) => _scanBarcode(event.barcode, emit));
  }

  void _scanBarcode(String? barcode, emit) {
    if (barcode == null) return;

    add(ScannerEventUpdateState(ScannerStateLoading()));
    // TODO stop rapid scanning
    _joinSession(barcode).then((result) {
      add(ScannerEventUpdateState(ScannerStateIdle()));
    });
  }

  void _updateState(ScannerEventUpdateState event, Emitter<ScannerState> emit) {
    log('ScannerBloc: updating state: ${event.state}');
    emit(event.state);
  }
}
