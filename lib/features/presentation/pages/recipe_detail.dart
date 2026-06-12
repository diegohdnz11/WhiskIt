import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/recipe_detail_cubit.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/favorites_cubit.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';
import 'package:recipe_test/core/api/recipe_api.dart';

import 'package:recipe_test/features/data/repository/favorites_storage.dart';

class RecipeDetail extends StatefulWidget {
  final String recipeId;

  const RecipeDetail({super.key, required this.recipeId});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  Widget build(BuildContext context) {
    context.read<FavoritesCubit>().isFavorite(widget.recipeId);

    return BlocProvider(
      create: (context) => RecipeDetailCubit(
        RecipeRepositoryImpl(RecipeApi(), FavoritesService()),
      )..getRecipeDetail(widget.recipeId),
      child: Builder(
        builder: (inside) {
          return Scaffold(
            appBar: AppBar(
              // add selected recipe title to appbar
              title: BlocSelector<RecipeDetailCubit, RecipeDetailState, String>(
                selector: (state) {
                  if (state.status == Status.success) {
                    return state.recipe!.title;
                  }
                  return 'Loading Recipe...';
                },
                builder: (context, title) {
                  return Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  );
                },
              ),

              //
              backgroundColor: Colors.brown[700],
              actions: [
                BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (i, favState) {
                    final isFav = favState.isFavorite;
                    return IconButton(
                      color: Colors.white,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                      ),
                      onPressed: () {
                        final detail = inside
                            .read<RecipeDetailCubit>()
                            .state
                            .recipe;
                        if (detail != null) {
                          inside.read<FavoritesCubit>().onOff(detail);
                          inside.read<FavoritesCubit>().isFavorite(detail.id);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
              builder: (context, state) {
                switch (state.status) {
                  case Status.loading:
                    return Center(child: CircularProgressIndicator());
                  case Status.error:
                    return Center(child: Text(state.text));
                  case Status.idle:
                    return SizedBox.shrink();
                  case Status.success:
                    final detailView = state.recipe!;
                    final ingredients = detailView.ingredients;
                    return ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            detailView.thumbnail,
                            height: 220,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          detailView.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 12),
                        if (ingredients.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredients',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(height: 8),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final ingredientItem in ingredients)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('• '),
                                        Expanded(child: Text(ingredientItem)),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        Text(
                          'Instructions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final String instructionsText =
                                detailView.instructions;
                            return Text(instructionsText);
                          },
                        ),
                      ],
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
