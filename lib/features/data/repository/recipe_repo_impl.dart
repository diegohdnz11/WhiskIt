import 'package:recipe_test/core/api/recipe_api.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/domain/repository/recipe_repo.dart';
import 'favorites_storage.dart';

class RecipeRepositoryImpl implements RecipeRepo {
  final RecipeApi api;
  final FavoritesService favoritesService;

  RecipeRepositoryImpl(this.api, this.favoritesService);

  @override
  Future<List<RecipeModel>> getRecipes(String search) async {
    final map = await api.search(search);
    final result = map['meals'];
    if (result == null) {
      throw Exception('Recipe Not Found');
    }
    final list = result as List;
    return list.map((block) => RecipeModel.fromMealJson(block)).toList();
  }

  @override
  //get recipe id to get detail
  Future<RecipeModel> getRecipeId(String id) async {
    final map = await api.lookup(id);
    final list = map['meals'] as List;
    return RecipeModel.fromMealJson(list.first);
  }

  @override
  Future<void> addFavorite(RecipeModel recipe) async {
    await favoritesService.toggleFav(recipe);
  }

  @override
  Future<List<RecipeModel>> getFavorites() async {
    return favoritesService.all();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return favoritesService.isFav(id);
  }
}
