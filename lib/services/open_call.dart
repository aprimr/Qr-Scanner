import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openCall(BuildContext context, {required String data}) async {
  if (data.isEmpty) return;
  final String phone = data.split(":")[1].toString();
  final uri = Uri(scheme: 'tel', path: phone);

  // Launch the phone dialer
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    showSnackbar(context, message: "Could not launch phone dialer");
  }
}
