import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code/widgets/qr_scanner_overlay.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool isFlashOn = false;
  bool isBackCam = true;

  final MobileScannerController _scannerController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                _scannerController.toggleTorch();
              },
              icon: HugeIcon(
                size: 24,
                icon: isFlashOn
                    ? HugeIcons.strokeRoundedFlashOff
                    : HugeIcons.strokeRoundedFlash,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(width: 14),
            IconButton(
              onPressed: () {
                setState(() {
                  isBackCam = !isBackCam;
                });
                _scannerController.switchCamera();
              },
              icon: HugeIcon(
                size: 24,
                icon: HugeIcons.strokeRoundedExchange01,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            SizedBox(width: 14),
            IconButton(
              onPressed: () {},
              icon: HugeIcon(
                size: 24,
                icon: HugeIcons.strokeRoundedImageUpload,
                color: Theme.of(context).colorScheme.outline,
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
                      'Place Qr code inside frame',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Theme.of(context).colorScheme.inverseSurface,
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
                      onDetect: (barcodes) {},
                    ),

                    // Scanner Overlay
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
