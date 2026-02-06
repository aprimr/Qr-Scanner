import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:qr_code/widgets/google_ads/banner_ad_widget.dart';
import 'package:share_plus/share_plus.dart';

class CreateBarcodeResult extends StatefulWidget {
  const CreateBarcodeResult({super.key});

  @override
  State<CreateBarcodeResult> createState() => _CreateBarcodeResultState();
}

class _CreateBarcodeResultState extends State<CreateBarcodeResult> {
  final GlobalKey _barcodeKey = GlobalKey();

  Future<Uint8List> _barcodeToImage() async {
    final boundary =
        _barcodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _saveBarcode() async {
    try {
      await Gal.requestAccess();
      final bytes = await _barcodeToImage();
      await Gal.putImageBytes(bytes, name: "my_barcode");
      if (mounted) showSnackbar(context, message: "Barcode saved to gallery");
    } catch (e) {
      if (!mounted) return;
      showSnackbar(context, message: "Failed to save barcode");
    }
  }

  Future<void> _shareBarcode() async {
    try {
      final bytes = await _barcodeToImage();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/barcode.png').create();
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: "Here is my Barcode",
          subject: "Barcode",
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showSnackbar(context, message: "Failed to share barcode");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Barcode",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    RepaintBoundary(
                      key: _barcodeKey,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Theme.of(context).colorScheme.surface,
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: args,
                          width: double.infinity,
                          height: 120,
                          drawText: false,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ActionBar(saveImage: _saveBarcode, share: _shareBarcode),
                  ],
                ),
              ),
            ),
            BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  final Future<void> Function() saveImage;
  final Future<void> Function() share;
  const ActionBar({super.key, required this.saveImage, required this.share});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            saveImage();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedDownloadSquare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            share();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedShare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
