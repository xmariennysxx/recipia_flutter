import 'package:recipia/model/favourite.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipia/theme/theme.dart';

class FavouriteDatabase extends ChangeNotifier {
  static late Isar isar;


  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([FavouriteSchema], directory: dir.path);
  }

  final List<Favourite> currentFavourite = [];

  
  Future<void> addFavourite(String name, String image, int recipeId) async {
    final newFavourite = Favourite()..newId = recipeId;

    newFavourite.newId = recipeId;
    newFavourite.image = image;
    newFavourite.name = name;

    await isar.writeTxn(() => isar.favourites.put(newFavourite));
    fetchFavourites();
  }

 
  Future<void> fetchFavourites() async {
    List<Favourite> fetchFavourites = await isar.favourites.where().findAll();
    currentFavourite.clear();
    currentFavourite.addAll(fetchFavourites);
    notifyListeners();
  }


  Future<void> updateFavourite(
      int id, String newname, String newimage, int newrecipeId) async {
    final existingFavourite = await isar.favourites.get(id);
    if (existingFavourite != null) {
      existingFavourite.image = newimage;
      existingFavourite.name = newimage;
      existingFavourite.newId = newrecipeId;
      await isar.writeTxn(() => isar.favourites.put(existingFavourite));
      await fetchFavourites();
    }
  }

 
  Future<void> deleteFavourite(int id) async {
    await isar.writeTxn(() => isar.favourites.delete(id));
    await fetchFavourites();
  }

  ThemeData _themeData = lightmode;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightmode) {
      themeData = darkmode;
    } else {
      themeData = lightmode;
    }
  }
}