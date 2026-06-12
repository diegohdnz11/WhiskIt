import 'package:bloc/bloc.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../states/recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  final RecipeRepositoryImpl repo;

  RecipeDetailCubit(this.repo) : super(RecipeDetailState.idle());

  Future<void> getRecipeDetail(String id) async {
    emit(RecipeDetailState.loading());
    try {
      final recipe = await repo.getRecipeId(id);
      emit(RecipeDetailState.success(recipe));
    } catch (error) {
      emit(RecipeDetailState.error(error.toString()));
    }
  }
}
