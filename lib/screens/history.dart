import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/models/qr_code_model.dart';
import 'package:qr_code/provider/history_provider.dart';
import 'package:qr_code/provider/theme_provider.dart';
import 'package:qr_code/utils/routes.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ThemeProvider>();
    final historyData = context.watch<HistoryProvider>();
    final scanHistoryList = historyData.scanHistory;

    if (scanHistoryList.isEmpty) {
      return Center(
        child: Text(
          "No history yet",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.outline,
            fontFamily: GoogleFonts.fredoka().fontFamily,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView.builder(
        itemCount: scanHistoryList.length,
        itemBuilder: (context, index) {
          final rawData = scanHistoryList[index];
          var parts = rawData.split("<~~[");
          final qrData = parts[0];
          final rawTime = parts[1].replaceAll(']>', "");
          final time =
              "${rawTime.split('T')[0]} ${rawTime.split('T')[1].split(":")[0]}:${rawTime.split('T')[1].split(":")[1]}";
          final parsedQrModel = QRCodeModel.fromRaw(qrData);

          // Determine icon and type label
          late final dynamic icon;
          late final String typeText;

          switch (parsedQrModel.type) {
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

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 1,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.scanResultRoute,
                  arguments: parsedQrModel,
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              leading: HugeIcon(
                icon: icon,
                strokeWidth: 1.5,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                parsedQrModel.rawData,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontFamily: GoogleFonts.fredoka().fontFamily,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    typeText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),

              trailing: IconButton(
                onPressed: () {
                  historyData.deleteHistory(rawData);
                },
                icon: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  size: 22,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
