import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openSms(BuildContext context, {required String data}) async {
  if (data.isEmpty) return;

  final parts = data.split(':');
  if (parts.length < 3) return;

  final phone = parts[1].trim();
  final message = parts.sublist(2).join(':').trim();

  final smsUri = Uri(
    scheme: 'sms',
    path: phone,
    queryParameters: {'body': message},
  );

  if (!await launchUrl(smsUri, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    showSnackbar(context, message: "Could not open WhatsApp");
  }
}
