import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/search_cubit.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';
import 'package:recipe_test/core/api/recipe_api.dart';
import 'package:recipe_test/features/data/models/recipe_model.dart';
import 'package:recipe_test/features/data/repository/favorites_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final text = TextEditingController();

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchCubit(RecipeRepositoryImpl(RecipeApi(), FavoritesService())),
      child: Builder(
        builder: (BuildContext builderContext) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F7F2),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: _HomeHeader(
                      onFavorites: () => builderContext.goNamed('favorites'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: _SearchField(
                      controller: text,
                      onSearch: () =>
                          builderContext.read<SearchCubit>().search(text.text),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case Status.loading:
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2A9D8F),
                              ),
                            );
                          case Status.error:
                            return _StateMessage(
                              icon: Icons.wifi_off_rounded,
                              title: 'Could not load recipes',
                              message: state.text,
                            );
                          case Status.empty:
                            return const _StateMessage(
                              icon: Icons.search_off_rounded,
                              title: 'No recipes found',
                              message: 'Try another ingredient or recipe name.',
                            );
                          case Status.idle:
                            return const _StateMessage(
                              icon: Icons.restaurant_menu_rounded,
                              title: 'Find your next meal',
                              message: 'Search by ingredient or recipe name.',
                            );
                          case Status.success:
                            return ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                              itemCount: state.results.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, i) {
                                final recipePreview = state.results[i];
                                return _RecipeListItem(
                                  recipe: recipePreview,
                                  onTap: () => context.goNamed(
                                    'recipe',
                                    params: {'recipeId': recipePreview.id},
                                  ),
                                );
                              },
                            );
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onFavorites});

  final VoidCallback onFavorites;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Recipe Book',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF243642),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),

            ],
          ),
        ),
        Material(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(8),
          child: IconButton(
            
            tooltip: 'Favorites',
            onPressed: onFavorites,
            icon: const Icon(Icons.favorite_border_rounded),
            color: const Color(0xFFE76F51),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onSearch});

  final TextEditingController controller;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => onSearch(),
        decoration: InputDecoration(
          hintText: 'Search recipes',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF2A9D8F),
          ),
          suffixIcon: IconButton(
            tooltip: 'Search',
            onPressed: onSearch,
            icon: const Icon(Icons.arrow_forward_rounded),
            color: const Color(0xFF243642),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE0E7DE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2A9D8F), width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  const _RecipeListItem({required this.recipe, required this.onTap});

  final RecipeModel recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final instructionsPreview = recipe.instructions.split('\n').first.trim();

    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  recipe.thumbnail,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 86,
                    height: 86,
                    color: const Color(0xFFE0E7DE),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Color(0xFF5D6F67),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF243642),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      instructionsPreview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF65736E),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF2A9D8F)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
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
