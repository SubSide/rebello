
import 'package:flutter/material.dart';
import 'package:presentation/src/ui/pages/scanner/barcode_scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Scan QR to join')
        ),
        body: const BarcodeScanner()
      );
  }
}