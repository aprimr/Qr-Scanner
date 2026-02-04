import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  List<String> _scanHistory = [];

  HistoryProvider() {
    _loadHistory();
  }

  // provider functions
  List<String> get scanHistory => _scanHistory.reversed.toList();

  void addToHistory(String qrData) {
    String now = DateTime.now().toIso8601String();
    String injectTime = "$qrData<~~[$now]>";
    _scanHistory.add(injectTime);
    _saveHistory();
    notifyListeners();
  }

  void deleteHistory(String qrData) {
    print(qrData);
    _scanHistory.removeWhere((history) => history == qrData);
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _scanHistory.clear();
    _saveHistory();
    notifyListeners();
  }

  // local Storage Func
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("scan-history", _scanHistory);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _scanHistory = prefs.getStringList('scan-history') ?? [];
    notifyListeners();
  }
}
