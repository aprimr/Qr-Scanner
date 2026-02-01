import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Qr Code Settings
  bool _vibrateOnScan = true;
  bool _beepOnScan = false;
  bool _saveScanHistory = true;

  // Qr Code Styles
  bool _isRoundedEyes = false;
  bool _isRoundedDots = false;

  SettingsProvider() {
    _loadSetting();
  }

  // get Qr Code Settings
  bool get vibrateOnScan => _vibrateOnScan;
  bool get beepOnScan => _beepOnScan;
  bool get saveScanHistory => _saveScanHistory;

  // get Qr Code Styles
  bool get isRoundedEyes => _isRoundedEyes;
  bool get isRoundedDots => _isRoundedDots;

  // toggle Qr code Settings
  void toggleVibrateOnScan(bool value) {
    _vibrateOnScan = value;
    _saveSetting();
    notifyListeners();
  }

  void toggleBeepOnScan(bool value) {
    _beepOnScan = value;
    _saveSetting();
    notifyListeners();
  }

  void toggleSaveScanHistory(bool value) {
    _saveScanHistory = value;
    _saveSetting();
    notifyListeners();
  }

  // toggle Qr code Styles
  void toggleRoundedEyes(bool value) {
    _isRoundedEyes = value;
    _saveSetting();
    notifyListeners();
  }

  void toggleRoundedDots(bool value) {
    _isRoundedDots = value;
    _saveSetting();
    notifyListeners();
  }

  // provider functions
  void _saveSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isRoundedEyes", _isRoundedEyes);
    prefs.setBool("isRoundedDots", _isRoundedDots);

    prefs.setBool("vibrateOnScan", _vibrateOnScan);
    prefs.setBool("beepOnScan", _beepOnScan);
    prefs.setBool("saveScanHistory", _saveScanHistory);
  }

  void _loadSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRoundedEyes = prefs.getBool('isRoundedEyes') ?? false;
    _isRoundedDots = prefs.getBool('isRoundedDots') ?? false;

    _vibrateOnScan = prefs.getBool('vibrateOnScan') ?? true;
    _beepOnScan = prefs.getBool('beepOnScan') ?? false;
    _saveScanHistory = prefs.getBool('saveScanHistory') ?? true;
    notifyListeners();
  }
}
