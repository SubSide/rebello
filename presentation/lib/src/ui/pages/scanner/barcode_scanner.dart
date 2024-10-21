import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:get_it/get_it.dart';

import 'bloc/scanner_bloc.dart';
import 'bloc/scanner_bloc_factory.dart';
import 'model/scanner_event.dart';
import 'model/scanner_state.dart';

class BarcodeScanner extends StatelessWidget {
  const BarcodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScannerBloc>(
        create: (context) => GetIt.I<ScannerBlocFactory>().create(),
        child: BlocBuilder<ScannerBloc, ScannerState>(builder: (context, state) {
          return _body(context);
        }));
  }

  Widget _body(BuildContext context) {
    final readerBloc = context.read<ScannerBloc>();

    return Stack(
      fit: StackFit.expand,
      children: [
        ReaderWidget(
          onScan: (result) => readerBloc.add(ScannerEventScanBarcode(result.text)),
          scanDelay: const Duration(milliseconds: 500),
        )
        ,
      ],
    );
  }
}