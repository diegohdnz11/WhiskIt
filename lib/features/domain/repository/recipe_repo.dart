import 'package:recipe_test/features/data/models/recipe_model.dart';

abstract class RecipeRepo{
  //search by meal name
  Future<List<RecipeModel>> getRecipes(String query);

  //id page detail
  Future<RecipeModel> getRecipeId(String id);

  //favorites
  Future<List<RecipeModel>> getFavorites();
  Future<void> addFavorite(RecipeModel recipe);
  Future<bool> isFavorite(String id);

}