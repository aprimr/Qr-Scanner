import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberCodePicker extends StatelessWidget {
  final Function(String dialCode) onCodeChanged;
  const NumberCodePicker({super.key, required this.onCodeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: CountryCodePicker(
        onChanged: (value) {
          onCodeChanged(value.dialCode ?? '');
        },
        pickerStyle: PickerStyle.bottomSheet,
        initialSelection: 'NP',
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: true,
        flagWidth: 18,
        padding: EdgeInsets.symmetric(horizontal: 4),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.fredoka().fontFamily,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),

        searchDecoration: InputDecoration(
          hintText: "Search country code",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontFamily: GoogleFonts.fredoka().fontFamily,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        headerTextStyle: TextStyle(
          fontSize: 20,
          fontFamily: GoogleFonts.fredoka().fontFamily,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),

        dialogBackgroundColor: Theme.of(context).colorScheme.surface,
        dialogSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),

        barrierColor: Colors.black54,

        dialogTextStyle: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
    );
  }
}
