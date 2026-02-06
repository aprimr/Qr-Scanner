import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class AppVersion extends StatefulWidget {
  const AppVersion({super.key});

  @override
  State<AppVersion> createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  String appVersion = 'v0.0.0';
  String buildNumber = '0';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        appVersion = '1.0.0';
        buildNumber = '1';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(
            "v-$appVersion ($buildNumber)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.outline,
              fontFamily: GoogleFonts.ubuntu().fontFamily,
            ),
          );
  }
}
