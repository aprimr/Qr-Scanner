import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/favourite_provider.dart';
import 'package:qr_code/provider/history_provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/provider/theme_provider.dart';
import 'package:qr_code/services/audio_player.dart';
import 'package:qr_code/utils/routes.dart';
import 'package:qr_code/widgets/app_version.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:vibration/vibration.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeProvider>();
    final settingsData = context.watch<SettingsProvider>();
    final settingsMethod = context.read<SettingsProvider>();
    final favouritesMethod = context.read<FavouriteProvider>();
    final historyMethod = context.read<HistoryProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.surface,
          settingsSectionBackground: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.surface,
          settingsSectionBackground: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        sections: [
          // General
          SettingsSection(
            title: _sectionTitle("General"),
            tiles: [
              SettingsTile(
                leading: HugeIcon(
                  icon: themeData.themeMode == ThemeMode.dark
                      ? HugeIcons.strokeRoundedSun03
                      : HugeIcons.strokeRoundedMoon02,
                ),
                title: _tileTitle(title: "Toggle Theme"),
                onPressed: (value) {
                  themeData.toggleTheme();
                },
              ),
              SettingsTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedUserSquare),
                title: _tileTitle(title: "My QR Code"),
                onPressed: (value) {
                  Navigator.pushNamed(context, AppRoutes.myQrCodeRoute);
                },
              ),
              SettingsTile.switchTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedSmartPhone03),
                title: _tileTitle(title: "Vibrate on Scan"),
                initialValue: settingsData.vibrateOnScan,
                onToggle: (value) async {
                  settingsMethod.toggleVibrateOnScan(value);
                  if (value == true && await Vibration.hasVibrator()) {
                    await Vibration.vibrate(duration: 200);
                  }
                },
              ),
              SettingsTile.switchTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedVolumeHigh),
                title: _tileTitle(title: "Beep on Scan"),
                initialValue: settingsData.beepOnScan,
                onToggle: (value) async {
                  if (value == true) {
                    beep();
                  }
                  settingsMethod.toggleBeepOnScan(value);
                },
              ),
              SettingsTile.switchTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedClock04),
                title: _tileTitle(title: "Save Scan History"),
                initialValue: settingsData.saveScanHistory,
                onToggle: (value) async {
                  settingsMethod.toggleSaveScanHistory(value);
                },
              ),
            ],
          ),

          // Qr Code Style
          SettingsSection(
            title: _sectionTitle("QR Code Style"),
            tiles: [
              SettingsTile.switchTile(
                initialValue: settingsData.isRoundedEyes,
                onToggle: (value) {
                  settingsMethod.toggleRoundedEyes(value);
                },
                leading: HugeIcon(icon: HugeIcons.strokeRoundedQrCode),
                title: _tileTitle(title: "QR Rounded Eyes"),
              ),
              SettingsTile.switchTile(
                initialValue: settingsData.isRoundedDots,
                onToggle: (value) {
                  settingsMethod.toggleRoundedDots(value);
                },
                leading: HugeIcon(icon: HugeIcons.strokeRoundedQrCode),
                title: _tileTitle(title: "QR Rounded Dots"),
              ),
            ],
          ),

          // App Settings
          SettingsSection(
            title: _sectionTitle("App Settings"),
            tiles: [
              SettingsTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: _tileTitle(title: "Clear Favourites", isDanger: true),
                onPressed: (value) {
                  favouritesMethod.clearFavourites();
                },
              ),
              SettingsTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete02,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: _tileTitle(title: "Clear Scan History", isDanger: true),
                onPressed: (value) {
                  historyMethod.clearHistory();
                },
              ),
            ],
          ),

          // App Settings
          SettingsSection(
            title: _sectionTitle("About"),
            tiles: [
              SettingsTile(
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                ),
                title: _tileTitle(title: "About App"),
                onPressed: (value) {
                  Navigator.pushNamed(context, AppRoutes.aboutRoute);
                },
              ),
              SettingsTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedStar),
                title: _tileTitle(title: "Rate this App"),
                onPressed: (value) {},
              ),
            ],
          ),

          SettingsSection(
            title: Column(
              children: [
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "ScanIt",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: GoogleFonts.ubuntu().fontFamily,
                      ),
                    ),
                    SizedBox(width: 10),
                    AppVersion(),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Made with ❤️",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.outline,
                        fontFamily: GoogleFonts.ubuntu().fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            tiles: [],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _tileTitle({required String title, bool isDanger = false}) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: GoogleFonts.fredoka().fontFamily,
        color: isDanger
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
