import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openWhatsApp(BuildContext context, {required String data}) async {
  if (data.isEmpty) return;

  final whatsappUrl = Uri.parse(data);

  if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    showSnackbar(context, message: "Could not open WhatsApp");
  }
}
