
import 'scanner_state.dart';

sealed class ScannerEvent {}

class ScannerEventUpdateState extends ScannerEvent {
  final ScannerState state;

  ScannerEventUpdateState(this.state);
}

class ScannerEventScanBarcode extends ScannerEvent {
  final String? barcode;

  ScannerEventScanBarcode(this.barcode);
}