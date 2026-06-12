import 'package:bloc/bloc.dart';
import 'package:recipe_test/features/data/repository/favorites_storage.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';

part '../states/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService heart;
  FavoritesCubit(this.heart) : super(FavoritesState.initial());

  void isFavorite(String id) {
    emit(state.copyWith(isFavorite: heart.isFav(id)));
  }

  void onOff(RecipeModel recipe) {
    heart.toggleFav(recipe);
    emit(state.copyWith(isFavorite: heart.isFav(recipe.id), items: heart.all()));
  }

  void loadHearts() {
    emit(state.copyWith(items: heart.all()));
  }
}