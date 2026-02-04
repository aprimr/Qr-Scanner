import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/provider/favourite_provider.dart';
import 'package:qr_code/provider/settings_provider.dart';
import 'package:qr_code/provider/theme_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
          ).colorScheme.outlineVariant,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).colorScheme.surface,
          settingsSectionBackground: Theme.of(
            context,
          ).colorScheme.outlineVariant,
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
              SettingsTile.switchTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedSmartPhone03),
                title: _tileTitle(title: "Vibrate on Scan"),
                initialValue: settingsData.vibrateOnScan,
                onToggle: (value) async {
                  settingsMethod.toggleVibrateOnScan(value);
                  if (await Vibration.hasVibrator()) {
                    await Vibration.vibrate(duration: 100);
                  }
                },
              ),
              SettingsTile.switchTile(
                leading: HugeIcon(icon: HugeIcons.strokeRoundedVolumeHigh),
                title: _tileTitle(title: "Beep on Scan"),
                initialValue: settingsData.beepOnScan,
                onToggle: (value) async {
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
                onPressed: (value) {},
              ),
            ],
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
