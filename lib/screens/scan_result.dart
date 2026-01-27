import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:qr_code/models/qr_code_model.dart';
import 'package:qr_code/widgets/buttons/toggle_theme_button.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({super.key});

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = false;
  }

  //----
  // Functions
  //----
  void _handleFavouriteTap() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeModel =
        ModalRoute.of(context)!.settings.arguments as QRCodeModel?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scan Result",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [
          ToggleThemeButton(),
          IconButton(
            onPressed: _handleFavouriteTap,
            icon: isFavourite
                ? Icon(
                    Icons.favorite_rounded,
                    color: Theme.of(context).colorScheme.error,
                  )
                : HugeIcon(icon: HugeIcons.strokeRoundedFavourite),
          ),

          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            // QR Type
            TypeBar(qrCodeModel: qrCodeModel!),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Scanned Result
                    ScannedResult(qrCodeModel: qrCodeModel),
                    SizedBox(height: 24),
                    //  Actions
                    ActionBar(),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

class TypeBar extends StatelessWidget {
  final QRCodeModel qrCodeModel;

  const TypeBar({super.key, required this.qrCodeModel});

  @override
  Widget build(BuildContext context) {
    late List<List<dynamic>> icon;
    late String typeText;

    switch (qrCodeModel.type) {
      case QRType.text:
        icon = HugeIcons.strokeRoundedText;
        typeText = "TEXT";
        break;
      case QRType.email:
        icon = HugeIcons.strokeRoundedMail01;
        typeText = "E-MAIL";
        break;
      case QRType.wifi:
        icon = HugeIcons.strokeRoundedWifi01;
        typeText = "WI-FI";
        break;
      case QRType.url:
        icon = HugeIcons.strokeRoundedLink03;
        typeText = "URL";
        break;
      case QRType.call:
        icon = HugeIcons.strokeRoundedCall02;
        typeText = "CALL";
        break;
      case QRType.sms:
        icon = HugeIcons.strokeRoundedMessage02;
        typeText = "SMS";
        break;
      case QRType.whatsApp:
        icon = HugeIcons.strokeRoundedWhatsapp;
        typeText = "WHATSAPP";
        break;
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 32,
              width: 32,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              child: HugeIcon(
                strokeWidth: 3,
                icon: icon,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            SizedBox(width: 8),
            Text(
              typeText,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.inverseSurface,
                fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class ScannedResult extends StatelessWidget {
  final QRCodeModel qrCodeModel;
  const ScannedResult({super.key, required this.qrCodeModel});

  @override
  Widget build(BuildContext context) {
    return Text(
      qrCodeModel.displayData,
      style: TextStyle(
        fontSize: 18,
        height: 1.5,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedSearch01,
          label: "Search",
          onTap: () => print("Search tapped"),
        ),
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedCopy01,
          label: "Copy",
          onTap: () => print("Copy tapped"),
        ),
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedSent,
          label: "Share",
          onTap: () => print("Share tapped"),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                size: 30,
                icon: icon,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.outline,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
