import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openUrl(BuildContext context, {required String data}) async {
  if (data.isEmpty) return;

  final uri = Uri.tryParse(data);
  if (uri == null) {
    if (context.mounted) {
      showSnackbar(context, message: "Invalid url");
    }
    return;
  }

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      showSnackbar(context, message: 'Could not launch browser');
    }
  }
}
