class RecipeModel {
  final String id;
  final String title;
  final String thumbnail;
  final String instructions;
  final List<String> ingredients;

  RecipeModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeModel.fromMealJson(Map<String, dynamic> json) {
    final items = <String>[];
    for (int i = 1; i <= 20; i++) {
      final pageIngredients = (json['strIngredient$i'] as String?)?.trim();
      final recipeIngredients = (json['strMeasure$i'] as String?)?.trim();
      if (pageIngredients != null && pageIngredients.isNotEmpty) {
        final finalIngredients = [
          if (recipeIngredients != null && recipeIngredients.isNotEmpty)
            recipeIngredients,
          pageIngredients,
        ].join(' ').trim();
        items.add(finalIngredients);
      }
    }
    return RecipeModel(
      id: json['idMeal'],
      title: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'],
      ingredients: items,
    );
  }

}
