import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:qr_code/widgets/buttons/toggle_theme_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class CreateResult extends StatefulWidget {
  const CreateResult({super.key});

  @override
  State<CreateResult> createState() => _CreateResultState();
}

class _CreateResultState extends State<CreateResult> {
  // key for saving Qr code
  final GlobalKey _qrCodeKey = GlobalKey();

  //---- Functions ----

  Future<Uint8List> _qrWidgetToImage() async {
    // convert widget to image
    final boundary =
        _qrCodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  Future<void> _saveQrImage() async {
    // request permission
    await Gal.requestAccess();
    // Qr Widet to image
    Uint8List pngBytes = await _qrWidgetToImage();
    // save
    await Gal.putImageBytes(pngBytes, name: "my_qr_code");
    if (mounted) {
      showSnackbar(context, message: "Image saved to gallery");
    }
  }

  Future<void> _share() async {
    // Qr Widet to image
    Uint8List pngBytes = await _qrWidgetToImage();
    // save to temp file
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/qr_code.png').create();
    await file.writeAsBytes(pngBytes);

    // Share
    await SharePlus.instance.share(
      ShareParams(
        title: 'QR Code',
        text: 'Here is my QR Code',
        files: [XFile(file.path)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final settingsData = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QR Code",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [ToggleThemeButton(), SizedBox(width: 8)],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: RepaintBoundary(
                        key: _qrCodeKey,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: QrImageView(
                            data: args,
                            eyeStyle: QrEyeStyle(
                              eyeShape: settingsData.isRoundedEyes
                                  ? QrEyeShape.circle
                                  : QrEyeShape.square,
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: settingsData.isRoundedDots
                                  ? QrDataModuleShape.circle
                                  : QrDataModuleShape.square,
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    ActionBar(saveImage: _saveQrImage, share: _share),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container(color: Colors.amber)),
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
