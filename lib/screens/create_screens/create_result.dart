import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:qr_code/widgets/buttons/toggle_theme_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateResult extends StatefulWidget {
  const CreateResult({super.key});

  @override
  State<CreateResult> createState() => _CreateResultState();
}

class _CreateResultState extends State<CreateResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "QR Code",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [ToggleThemeButton(), SizedBox(width: 8)],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: QrImageView(
                        data: "data",
                        eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.circle),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                        ),
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.inverseSurface,
                      ),
                    ),
                    SizedBox(height: 30),
                    ActionBar(),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container(color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}

class ActionBar extends StatelessWidget {
  const ActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedDownloadSquare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HugeIcon(
                  size: 30,
                  icon: HugeIcons.strokeRoundedShare01,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.outline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
