import 'package:bloc/bloc.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';

part '../states/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final RecipeRepositoryImpl repo;
  SearchCubit(this.repo) : super(SearchState.idle())
  //quick start home page initial recipes
  {
    freshStartRecipes();
  }
  Future<void> freshStartRecipes() async {
    await search('v');
  }

  //

  Future<void> search(String search) async {
    if (search.trim().isEmpty) {
      emit(SearchState.idle());
      return;
    }
    emit(SearchState.loading());
    try {
      final results = await repo.getRecipes(search);
      if (results.isEmpty) {
        emit(SearchState.empty());
      } else {
        emit(SearchState.success(results));
      }
    } catch (e) {
      emit(SearchState.error(e.toString()));
    }
  }
}