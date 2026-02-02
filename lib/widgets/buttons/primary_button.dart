import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onSubmit;
  final String label;
  const PrimaryButton({super.key, required this.onSubmit, required this.label});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onSubmit,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.fredoka().fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
