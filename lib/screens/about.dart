import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.poppins();
    final theme = Theme.of(context);
    final appName = "ScanIt - QR Code & Barcode Scanner";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          "About",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Text(
              appName,
              style: textStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "v-1.0.0",
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.outline,
                fontFamily: GoogleFonts.fredoka().fontFamily,
              ),
            ),

            const SizedBox(height: 30),

            /// About
            _sectionTitle("About App"),
            const SizedBox(height: 12),
            Text(
              "$appName is a lightweight yet powerful utility designed for everyday use. "
              "It supports advanced scanning and creation of both QR codes and barcodes, "
              "along with customization and smart result handling — while keeping all your data stored locally on your device.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 36),

            /// Features
            _sectionTitle("Features"),
            const SizedBox(height: 16),

            _bullet("Scan QR codes and barcodes using camera"),
            _bullet("Scan QR and barcode from gallery images"),
            _bullet("Flashlight support and camera switching"),
            _bullet(
              "Create QR codes for Text, URL, WiFi, Email, Phone, SMS, WhatsApp",
            ),
            _bullet("Personal 'My QR Code' generation"),
            _bullet("Copy, share, or favorite scanned results"),
            _bullet("Save created QR or barcode images directly to device"),
            _bullet("Scan history and favorites management"),
            _bullet("Clear scan history and favorites anytime"),

            const SizedBox(height: 40),

            // PRIVACY POLICY
            _sectionTitle("Privacy Policy"),
            const SizedBox(height: 18),

            _subHeading("Permissions"),
            const SizedBox(height: 8),
            _bullet(
              "Camera permission is required for scanning QR codes and barcodes.",
            ),
            _bullet(
              "Storage permission is used to save generated QR/barcode images and scan images from your gallery.",
            ),

            const SizedBox(height: 20),

            _subHeading("Data Collection & Storage"),
            const SizedBox(height: 8),
            Text(
              "$appName does not collect, store, or transmit any personal information such as "
              "name, email, phone number, or location. All data including scanned results, created QR/barcodes, "
              "scan history, favorites, and preferences are stored locally on your device only. "
              "No cloud sync, analytics, or crash reporting is implemented.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 16),
            Text(
              "Scan history is retained until the user manually clears it. To ensure smooth performance, "
              "if scan history exceeds 200 entries, the oldest 50 entries are automatically deleted. "
              "Favorites remain until manually cleared by the user.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Smart Actions"),
            const SizedBox(height: 8),
            Text(
              "When scanning QR codes or barcodes, the app provides smart actions based on the scanned content: "
              "URLs can be opened directly in the browser, emails can be composed, phone numbers can be dialed, "
              "SMS and WhatsApp messages can be sent, and text can be copied or searched on the web. "
              "All these actions are performed using the device's native apps. "
              "No scanned data is sent to our servers or any third party.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Advertising"),
            const SizedBox(height: 8),
            Text(
              "This application uses Google AdMob to display advertisements. AdMob may collect device identifiers "
              "and usage data according to Google's Privacy Policy. We do not access, collect, or control "
              "any of this data. Ads are generic and do not require any personal information from the user.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Children’s Privacy"),
            const SizedBox(height: 8),
            Text(
              "This application is designed for users of all ages and does not knowingly collect personal information "
              "from children under 13. Parents and guardians are encouraged to supervise children's use of the app.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Security"),
            const SizedBox(height: 8),
            Text(
              "All data is stored locally on the device in plain text to ensure accessibility and easy QR/barcode handling. "
              "Users are responsible for their device security. We do not encrypt scan history or created codes, "
              "as QR and barcode data are generally non-sensitive and intended for user convenience.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Third-Party Services"),
            const SizedBox(height: 8),
            Text(
              "Apart from Google AdMob for advertising, the application does not use any third-party SDKs, analytics tools, "
              "or crash reporting services.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),

            const SizedBox(height: 20),

            _subHeading("Changes to this Policy"),
            const SizedBox(height: 8),
            Text(
              "We may update this Privacy Policy from time to time. Any changes will be reflected in this section of the app. "
              "Users are encouraged to review this policy periodically for updates.",
              style: textStyle.copyWith(fontSize: 14, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _subHeading(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }
}
