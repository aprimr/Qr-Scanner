import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({super.key});

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  bool isFavourite = true;

  //----
  // Functions
  //----
  void _handleFavouriteTap() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BarcodeCapture;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Scan Result",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleFavouriteTap,
            icon: isFavourite
                ? Icon(
                    Icons.favorite_rounded,
                    color: Theme.of(context).colorScheme.error,
                  )
                : HugeIcon(icon: HugeIcons.strokeRoundedFavourite),
          ),

          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scanned Result
                  Text(
                    args.barcodes.first.rawValue!,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  SizedBox(height: 20),

                  //  Actions
                  ActionBar(),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.red)),
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
      children: [
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedSearch01,
          label: "Search",
          onTap: () => print("Search tapped"),
        ),
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedCopy01,
          label: "Copy",
          onTap: () => print("Copy tapped"),
        ),
        _buildActionButton(
          context,
          icon: HugeIcons.strokeRoundedSent,
          label: "Share",
          onTap: () => print("Share tapped"),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required List<List<dynamic>> icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                size: 30,
                icon: icon,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.outline,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
