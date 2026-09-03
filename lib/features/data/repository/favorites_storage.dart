import 'dart:convert';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  FavoritesService._(this._preferences);

  static const _storageKey = 'favorite_recipes';
  final SharedPreferences _preferences;
  final Map<String, RecipeModel> _favoriteStorage = {};

  static Future<FavoritesService> create() async {
    final service = FavoritesService._(await SharedPreferences.getInstance());
    service._load();
    return service;
  }

  void _load() {
    final savedFavorites = _preferences.getString(_storageKey);
    if (savedFavorites == null) return;

    try {
      final decoded = jsonDecode(savedFavorites);
      if (decoded is! List) return;

      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final recipe = RecipeModel.fromFavoriteJson(item);
          _favoriteStorage[recipe.id] = recipe;
        }
      }
    } catch (_) {
      _favoriteStorage.clear();
    }
  }

  bool isFav(String id) => _favoriteStorage.containsKey(id);

  Future<void> toggleFav(RecipeModel heart) async {
    if (_favoriteStorage.containsKey(heart.id)) {
      _favoriteStorage.remove(heart.id);
    } else {
      _favoriteStorage[heart.id] = heart;
    }
    await _save();
  }

  Future<void> _save() => _preferences.setString(
    _storageKey,
    jsonEncode(
      _favoriteStorage.values.map((recipe) => recipe.toFavoriteJson()).toList(),
    ),
  );

  List<RecipeModel> all() => List.unmodifiable(_favoriteStorage.values);
}
