import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackbar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0.0,
      backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.inverseSurface,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        maxLines: 1,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
          color: isError
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.surface,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    ),
  );
}
