import 'dart:collection';
import 'package:recipe_test/features/data/models/recipe_model.dart';

class FavoritesService {
  final Map<String, RecipeModel> favoriteStorage = HashMap();

  bool isFav(String id) => favoriteStorage.containsKey(id);

  void toggleFav(RecipeModel heart) {
    if(favoriteStorage.containsKey(heart.id)) {
      favoriteStorage.remove(heart.id);
    } else {
      favoriteStorage[heart.id] = heart;
    }
  }
  List<RecipeModel> all() => favoriteStorage.values.toList();
}