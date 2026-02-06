import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> _favourites = [];

  FavouriteProvider() {
    _loadFavourites();
  }

  // Favourite Functions
  List<String> get favourites => _favourites.reversed.toList();

  void toggleFavourites(String data) {
    if (_favourites.contains(data)) {
      _favourites.remove(data);
    } else {
      _favourites.add(data);
    }
    _saveFavourites();
    notifyListeners();
  }

  bool containsFavourite(String data) {
    return _favourites.contains(data);
  }

  void clearFavourites() {
    _favourites.clear();
    _saveFavourites();
    notifyListeners();
  }

  // local Storage Func
  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favourites", _favourites);
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    _favourites = prefs.getStringList('favourites') ?? [];
    notifyListeners();
  }
}
