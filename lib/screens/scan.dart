import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/qr_scanner_overlay.dart';
import 'package:qr_code/widgets/snackbar.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool isFlashOn = false;
  bool isBackCam = true;
  bool isScanned = false;
  final MobileScannerController _scannerController = MobileScannerController();

  //----
  // Flash and Cam Functions
  //----
  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    _scannerController.toggleTorch();
  }

  void _toggleCam() {
    setState(() {
      isFlashOn = false;
      isBackCam = !isBackCam;
    });
    _scannerController.switchCamera();
  }

  //----
  // QR Functions
  //----
  void _onDetect(BarcodeCapture result) {
    if (isScanned == true) return;

    final String code = result.barcodes.first.rawValue!;

    //----
    // Return if the reslult is null
    //----
    if (code.isEmpty) {
      setState(() {
        isScanned = false;
      });
      return;
    }

    //----
    // If scan success, set `isScanned` true
    // And if flashOn, set `isFlashOn` false and toggle torch
    //----
    if (code.isNotEmpty) {
      setState(() {
        isScanned = true;
        if (isFlashOn) {
          isFlashOn = false;
          _scannerController.toggleTorch();
        }
      });

      Navigator.pushNamed(
        context,
        AppRoutes.scanResultRoute,
        arguments: {'qrData': result},
      ).then((_) {
        //----
        // If screen mounts, set `isScanned` to false
        // so that user can scan another QR
        //----
        if (mounted) {
          setState(() {
            isScanned = false;
          });
        }
      });
    }
  }

  void _onDetectError(Object error, StackTrace stackTrace) {
    showSnackbar(context, message: error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _toggleFlash,
              icon: HugeIcon(
                size: 24,
                icon: isFlashOn
                    ? HugeIcons.strokeRoundedFlashOff
                    : HugeIcons.strokeRoundedFlash,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            SizedBox(width: 14),
            IconButton(
              onPressed: _toggleCam,
              icon: HugeIcon(
                size: 24,
                icon: HugeIcons.strokeRoundedExchange01,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            SizedBox(width: 14),
            IconButton(
              onPressed: () {},
              icon: HugeIcon(
                size: 24,
                icon: HugeIcons.strokeRoundedImageUpload,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Place QR code inside frame',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: GoogleFonts.googleSans().fontFamily,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: _onDetect,
                      onDetectError: _onDetectError,
                    ),

                    //----
                    // Scanner Overlay
                    //----
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ScannerOverlayPainter(
                          bgColor: Theme.of(context).colorScheme.surface,
                          borderColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
