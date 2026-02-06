import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/models/qr_code_model.dart';
import 'package:qr_code/provider/history_provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/services/audio_player.dart';
import 'package:qr_code/services/pick_image_from_gallery.dart';
import 'package:qr_code/services/scan_qr_from_image.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/google_ads/banner_ad_widget.dart';
import 'package:qr_code/widgets/qr_scanner_overlay.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:vibration/vibration.dart';

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
  late final SettingsProvider settingsData;
  late final HistoryProvider historyData;

  @override
  void initState() {
    super.initState();
    settingsData = Provider.of<SettingsProvider>(context, listen: false);
    historyData = Provider.of<HistoryProvider>(context, listen: false);
  }

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
  void _onDetect(BarcodeCapture result) async {
    if (isScanned == true) return;

    final String code = result.barcodes.first.rawValue ?? "";
    final QRCodeModel qrCodeModel = QRCodeModel.fromRaw(code);

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

      // beep on scan
      if (settingsData.beepOnScan) {
        beep();
      }
      // Vibrate on scan
      if (await Vibration.hasVibrator() && settingsData.vibrateOnScan) {
        Vibration.vibrate(duration: 200);
      }
      // save Scan History
      if (settingsData.saveScanHistory) {
        historyData.addToHistory(qrCodeModel.rawData);
      }
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.scanResultRoute,
        arguments: qrCodeModel,
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

  Future<void> scanFromGallery() async {
    final file = await pickImageFromGallery();

    if (file == null) return;

    final result = await scanQrFromImage(file);

    if (result == null) {
      if (!mounted) return;
      showSnackbar(context, message: "No Qr Code detected");
    } else {
      final QRCodeModel qrCodeModel = QRCodeModel.fromRaw(result);
      // Vibrate on scan
      if (await Vibration.hasVibrator() && settingsData.vibrateOnScan) {
        Vibration.vibrate(duration: 200);
      }
      // save Scan History
      if (settingsData.saveScanHistory) {
        historyData.addToHistory(qrCodeModel.rawData);
      }
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.scanResultRoute,
        arguments: qrCodeModel,
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
              onPressed: scanFromGallery,
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
              BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
