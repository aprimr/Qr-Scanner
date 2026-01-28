import 'package:flutter/material.dart';
import 'package:qr_code/services/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

void openMail(BuildContext context, {required String data}) async {
  if (!data.startsWith('MATMSG:')) return;

  // Remove prefix
  final content = data.replaceFirst('MATMSG:', '').replaceAll(';;', '');
  final parts = content.split(';');

  String to = '';
  String subject = '';
  String body = '';

  for (var part in parts) {
    if (part.startsWith('TO:')) {
      to = part.replaceFirst('TO:', '').trim();
    } else if (part.startsWith('SUB:')) {
      subject = part.replaceFirst('SUB:', '').trim();
    } else if (part.startsWith('BODY:')) {
      body = part.replaceFirst('BODY:', '').trim();
    }
  }

  // If no [TO] return
  if (to.isEmpty) return;

  final mailUri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: {
      if (subject.isNotEmpty) 'subject': subject,
      if (body.isNotEmpty) 'body': body,
    },
  );

  if (!await launchUrl(mailUri, mode: LaunchMode.externalApplication)) {
    if (!context.mounted) return;
    showSnackbar(context, message: "Error launching email client");
  }
}
