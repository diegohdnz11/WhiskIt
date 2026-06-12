import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/domain/repository/recipe_repo.dart';

class addFavorite {
  final RecipeRepo repo;
  addFavorite(this.repo);
  Future<void> call(RecipeModel recipe) => repo.addFavorite(recipe);
}

class IsFavorite {
  final RecipeRepo repo;
  IsFavorite(this.repo);
  Future<bool> call(String id) => repo.isFavorite(id);
}

class GetFavorites {
  final RecipeRepo repo;
  GetFavorites(this.repo);
  Future<List<RecipeModel>> call() => repo.getFavorites();
}