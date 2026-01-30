import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/screens/create_screens/create_email_qr.dart';
import 'package:qr_code/screens/create_screens/create_phone_qr.dart';
import 'package:qr_code/screens/create_screens/create_sms_qr.dart';
import 'package:qr_code/screens/create_screens/create_text_qr.dart';
import 'package:qr_code/screens/create_screens/create_url_qr.dart';
import 'package:qr_code/screens/create_screens/create_whatsapp_qr.dart';
import 'package:qr_code/screens/create_screens/create_wifi_qr.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              enableFeedback: true,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: GoogleFonts.googleSans().fontFamily,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.outline,
                fontFamily: GoogleFonts.googleSans().fontFamily,
              ),
              tabs: [
                Tab(text: "Text"),
                Tab(text: "URL"),
                Tab(text: "WiFi"),
                Tab(text: "Email"),
                Tab(text: "Phone"),
                Tab(text: "SMS"),
                Tab(text: "WhatsApp"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  CreateTextQr(),
                  CreateUrlQr(),
                  CreateWifiQr(),
                  CreateEmailQr(),
                  CreatePhoneQr(),
                  CreateSmsQr(),
                  CreateWhatsappQr(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
