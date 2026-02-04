import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/models/qr_code_model.dart';
import 'package:qr_code/provider/favourite_provider.dart';
import 'package:qr_code/services/connect_wifi.dart';
import 'package:qr_code/services/copy_to_clipboard.dart';
import 'package:qr_code/services/open_call.dart';
import 'package:qr_code/services/open_mail.dart';
import 'package:qr_code/services/open_sms.dart';
import 'package:qr_code/services/open_url.dart';
import 'package:qr_code/services/open_whatsapp.dart';
import 'package:qr_code/services/search_web.dart';
import 'package:share_plus/share_plus.dart';

class _ActionItem {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  _ActionItem({required this.icon, required this.label, required this.onTap});
}

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
  void _handleFavouriteTap(BuildContext context, {required String data}) {
    final favouritesMethod = context.read<FavouriteProvider>();
    favouritesMethod.toggleFavourites(data);
  }

  @override
  Widget build(BuildContext context) {
    final qrCodeModel =
        ModalRoute.of(context)!.settings.arguments as QRCodeModel?;

    if (qrCodeModel == null) {
      return const Scaffold(body: Center(child: Text("No QR data found")));
    }

    final favouritesData = context.watch<FavouriteProvider>();
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
          IconButton(
            onPressed: () {
              _handleFavouriteTap(context, data: qrCodeModel.rawData);
            },
            icon: favouritesData.containsFavourite(qrCodeModel.rawData)
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
            TypeBar(qrCodeModel: qrCodeModel),
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scanned Result
                    ScannedResult(qrCodeModel: qrCodeModel),
                    SizedBox(height: 24),
                    //  Actions
                    ActionBar(
                      qrCodeModel: qrCodeModel,
                      scannedData: qrCodeModel.displayData,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
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
        typeText = "PHONE";
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
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
              child: HugeIcon(
                strokeWidth: 1.5,
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
  final QRCodeModel qrCodeModel;
  final String scannedData;

  const ActionBar({
    super.key,
    required this.qrCodeModel,
    required this.scannedData,
  });

  @override
  Widget build(BuildContext context) {
    final actions = _getActions(
      context,
      qrCodeModel: qrCodeModel,
      scannedData: scannedData,
    );

    return Row(
      children: actions
          .map(
            (action) => Expanded(
              child: InkWell(
                onTap: action.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        size: 30,
                        icon: action.icon,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          action.label,
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
            ),
          )
          .toList(),
    );
  }

  List<_ActionItem> _getActions(
    BuildContext context, {
    required QRCodeModel qrCodeModel,
    required String scannedData,
  }) {
    final List<_ActionItem> actions = [];

    switch (qrCodeModel.type) {
      case QRType.email:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedMail01,
            label: "Mail It",
            onTap: () {
              openMail(context, data: qrCodeModel.rawData);
            },
          ),
        );
        break;

      case QRType.url:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedLinkSquare02,
            label: "Open Link",
            onTap: () {
              openUrl(context, data: scannedData);
            },
          ),
        );
        break;

      case QRType.wifi:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedWifi01,
            label: "Connect",
            onTap: () {
              connectWifi();
            },
          ),
        );
        break;

      case QRType.call:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedCallRinging04,
            label: "Call",
            onTap: () {
              openCall(context, data: qrCodeModel.rawData);
            },
          ),
        );
        break;

      case QRType.whatsApp:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedLinkSquare02,
            label: "Open WhatsApp",
            onTap: () {
              openWhatsApp(context, data: qrCodeModel.rawData);
            },
          ),
        );
        break;

      case QRType.sms:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedLinkSquare02,
            label: "Send Sms",
            onTap: () {
              openSms(context, data: qrCodeModel.rawData);
            },
          ),
        );
        break;

      default:
        actions.add(
          _ActionItem(
            icon: HugeIcons.strokeRoundedSearch01,
            label: "Web Search",
            onTap: () {
              webSearch(context, data: scannedData);
            },
          ),
        );
    }

    // Always-visible actions
    actions.addAll([
      _ActionItem(
        icon: HugeIcons.strokeRoundedCopy01,
        label: "Copy",
        onTap: () {
          copyToClipboard(data: scannedData);
        },
      ),
      _ActionItem(
        icon: HugeIcons.strokeRoundedShare01,
        label: "Share",
        onTap: () async {
          await SharePlus.instance.share(
            ShareParams(title: 'Scanned Result', text: qrCodeModel.rawData),
          );
        },
      ),
    ]);

    return actions;
  }
}
