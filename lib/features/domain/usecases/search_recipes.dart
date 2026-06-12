import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/domain/repository/recipe_repo.dart';

class SearchRecipe{
  final RecipeRepo repo;
  SearchRecipe(this.repo);

  Future<Future<List<RecipeModel>>> call(String query) async{
    return repo.getRecipes(query);
  }

}
