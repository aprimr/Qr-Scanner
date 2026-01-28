import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void webSearch(BuildContext context, {required String data}) async {
  if (data.isEmpty) return;

  final encodedQuery = Uri.encodeComponent(data);
  final searchUrl = Uri.parse('https://www.google.com/search?q=$encodedQuery');

  if (!await launchUrl(searchUrl, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      showSnackbar(context, message: "Error launching browser");
    }
  }
}
