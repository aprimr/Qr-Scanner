import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/models/qr_code_model.dart';
import 'package:qr_code/provider/favourite_provider.dart';
import 'package:qr_code/utils/routes.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    final favouriteData = context.watch<FavouriteProvider>();
    final favouriteList = favouriteData.favourites;

    if (favouriteList.isEmpty) {
      return Center(
        child: Text(
          "No favourites yet",
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
        itemCount: favouriteList.length,
        itemBuilder: (context, index) {
          final rawData = favouriteList[index];
          final parsedQrModel = QRCodeModel.fromRaw(rawData);

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
            color: Theme.of(context).colorScheme.outlineVariant,
            elevation: 0.5,
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
                parsedQrModel.displayData,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontFamily: GoogleFonts.fredoka().fontFamily,
                ),
              ),
              subtitle: Text(
                typeText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),

              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
