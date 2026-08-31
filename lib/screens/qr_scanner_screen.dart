import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/qr_location_model.dart';
import '../services/qr_service.dart';
import 'indoor_map_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final QrService qrService = QrService();

  bool isProcessing = false;

  Future<void> _handleQrCode(String qrCode) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    final QrLocationModel? location =
    await qrService.getLocationFromQr(qrCode);

    if (!mounted) return;

    if (location == null) {
      setState(() {
        isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR code "$qrCode" is not registered.'),
        ),
      );

      return;
    }

    controller.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IndoorMapScreen(
          currentLocation: location.locationName,
          destination: 'Select Destination',
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Campus QR'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final value = barcode.rawValue;

                if (value != null && value.isNotEmpty) {
                  _handleQrCode(value);
                  break;
                }
              }
            },
          ),

          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          const Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Text(
              'Scan a CampusNav QR code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          if (isProcessing)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}