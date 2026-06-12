import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/domain/repository/recipe_repo.dart';


class GetRecipeDetail{
  final RecipeRepo repo;
  GetRecipeDetail(this.repo);

  Future<RecipeModel> call(String id){
    return repo.getRecipeId(id);
  }

}
