part of '../cubits/favorites_cubit.dart';

class FavoritesState {
  final bool isFavorite;
  final List<RecipeModel> items;

  FavoritesState({required this.isFavorite, required this.items});

  factory FavoritesState.initial() =>
      FavoritesState(isFavorite: false, items: const []);

  FavoritesState copyWith({bool? isFavorite, List<RecipeModel>? items}) {
    final bool resolvedIsFavorite;
    if (isFavorite != null) {
      resolvedIsFavorite = isFavorite;
    } else {
      resolvedIsFavorite = this.isFavorite;
    }

    final List<RecipeModel> finalItems;
    if (items != null) {
      finalItems = items;
    } else {
      finalItems = this.items;
    }

    return FavoritesState(isFavorite: resolvedIsFavorite, items: finalItems);
  }
}
