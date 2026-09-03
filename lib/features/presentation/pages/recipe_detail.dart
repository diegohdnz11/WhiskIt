import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_test/core/api/recipe_api.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/data/repository/favorites_storage.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/favorites_cubit.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/recipe_detail_cubit.dart';

class RecipeDetail extends StatefulWidget {
  final String recipeId;

  const RecipeDetail({super.key, required this.recipeId});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().isFavorite(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeDetailCubit(
        RecipeRepositoryImpl(RecipeApi(), context.read<FavoritesService>()),
      )..getRecipeDetail(widget.recipeId),
      child: Builder(
        builder: (inside) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F7F2),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
                      builder: (context, state) {
                        return _DetailHeader(
                          title: state.recipe?.title ?? 'Recipe Details',
                          onBack: () {
                            if (Navigator.of(context).canPop()) {
                              context.pop();
                            } else {
                              context.go('/');
                            }
                          },
                          favoriteButton:
                              BlocBuilder<FavoritesCubit, FavoritesState>(
                                builder: (context, favState) {
                                  final isFav = favState.isFavorite;
                                  return IconButton(
                                    tooltip: isFav
                                        ? 'Remove favorite'
                                        : 'Add favorite',
                                    color: const Color(0xFFE76F51),
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                    ),
                                    onPressed: () {
                                      final recipe = inside
                                          .read<RecipeDetailCubit>()
                                          .state
                                          .recipe;
                                      if (recipe != null) {
                                        inside.read<FavoritesCubit>().onOff(
                                          recipe,
                                        );
                                        inside
                                            .read<FavoritesCubit>()
                                            .isFavorite(recipe.id);
                                      }
                                    },
                                  );
                                },
                              ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case Status.loading:
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2A9D8F),
                              ),
                            );
                          case Status.error:
                            return const _DetailStateMessage(
                              icon: Icons.wifi_off_rounded,
                              title: 'Could not load recipe',
                              message:
                                  'Check your connection and try opening it again.',
                            );
                          case Status.idle:
                            return const SizedBox.shrink();
                          case Status.success:
                            return _RecipeDetailView(recipe: state.recipe!);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.title,
    required this.onBack,
    required this.favoriteButton,
  });

  final String title;
  final VoidCallback onBack;
  final Widget favoriteButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(8),
          child: IconButton(
            tooltip: 'Back',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: const Color(0xFF243642),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF243642),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(8),
          child: favoriteButton,
        ),
      ],
    );
  }
}

class _RecipeDetailView extends StatelessWidget {
  const _RecipeDetailView({required this.recipe});

  final RecipeModel recipe;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            recipe.thumbnail,
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 240,
              color: const Color(0xFFE0E7DE),
              child: const Icon(
                Icons.restaurant_rounded,
                color: Color(0xFF5D6F67),
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          recipe.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF243642),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        if (recipe.ingredients.isNotEmpty)
          _DetailSection(
            title: 'Ingredients',
            icon: Icons.shopping_basket_outlined,
            child: Column(
              children: [
                for (final ingredient in recipe.ingredients)
                  _IngredientRow(ingredient: ingredient),
              ],
            ),
          ),
        if (recipe.ingredients.isNotEmpty) const SizedBox(height: 14),
        _DetailSection(
          title: 'Instructions',
          icon: Icons.menu_book_rounded,
          child: Text(
            recipe.instructions,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF485A54),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF2A9D8F), size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF243642),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient});

  final String ingredient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF2A9D8F),
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF485A54),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailStateMessage extends StatelessWidget {
  const _DetailStateMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46, color: const Color(0xFF2A9D8F)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF243642),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF65736E)),
            ),
          ],
        ),
      ),
    );
  }
}
