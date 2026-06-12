part of '../cubits/recipe_detail_cubit.dart';

enum Status { 
  idle, 
  loading, 
  success, 
  error 
}

class RecipeDetailState{
  final Status status;
  final RecipeModel? recipe;
  final String text;

  const RecipeDetailState({
    required this.status,
    this.recipe,
    required this.text,
  });

  RecipeDetailState.idle() : this(status: Status.idle, text: '');
  RecipeDetailState.loading() : this(status: Status.loading, text: '');
  RecipeDetailState.success(RecipeModel recipe) : this(status: Status.success, recipe: recipe, text: '');
  RecipeDetailState.error(String string) : this(status: Status.error, text: '');


}