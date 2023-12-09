import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcodeCapture) async {
          if (barcodeCapture.barcodes.isEmpty) return;

          final barcode = barcodeCapture.barcodes[0];

          AppNavigator.pop(
            barcode.rawValue,
          );
        },
        controller: _controller,
        errorBuilder: (_, exception, child) {
          return const SizedBox.shrink();
        },
        fit: BoxFit.cover,
      ),
    );
  }
}
