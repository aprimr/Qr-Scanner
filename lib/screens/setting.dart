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
                leading: Icon(
                  themeData.themeMode == ThemeMode.dark
                      ? Icons.sunny
                      : Icons.dark_mode,
                ),
                title: Text("Toggle Theme"),
                onPressed: (value) {
                  themeData.toggleTheme();
                },
              ),
              SettingsTile.switchTile(
                leading: Icon(Icons.vibration),
                title: Text("Vibrate on Scan"),
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
                title: Text("Beep on Scan"),
                initialValue: settingsData.beepOnScan,
                onToggle: (value) async {
                  settingsMethod.toggleBeepOnScan(value);
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
                leading: Icon(Icons.qr_code_outlined),
                title: Text("QR Rounded Eyes"),
              ),
              SettingsTile.switchTile(
                initialValue: settingsData.isRoundedDots,
                onToggle: (value) {
                  settingsMethod.toggleRoundedDots(value);
                },
                leading: Icon(Icons.qr_code_outlined),
                title: Text("QR Rounded Dots"),
              ),
            ],
          ),

          // App Settings
          SettingsSection(
            title: _sectionTitle("App Settings"),
            tiles: [
              SettingsTile.switchTile(
                leading: Icon(Icons.history),
                title: Text("Save Scan History"),
                initialValue: settingsData.saveScanHistory,
                onToggle: (value) async {
                  settingsMethod.toggleSaveScanHistory(value);
                },
              ),
              SettingsTile(
                leading: Icon(
                  Icons.auto_delete_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  "Clear Favourites",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: (value) {
                  favouritesMethod.clearFavourites();
                },
              ),
              SettingsTile(
                leading: Icon(
                  Icons.auto_delete_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  "Clear Scan History",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
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
}
