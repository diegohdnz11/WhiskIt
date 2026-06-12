import 'package:go_router/go_router.dart';
import 'package:recipe_test/features/presentation/pages/favorites.dart';
import 'package:recipe_test/features/presentation/pages/home.dart';
import 'package:recipe_test/features/presentation/pages/recipe_detail.dart';

class AppRoute{
  GoRouter get router => GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(child: HomePage()),

        routes:[
          GoRoute(
            path: 'favorites',
            name: 'favorites',
            pageBuilder: (context, state) => NoTransitionPage(child: FavoritesPage()),
          ),
          GoRoute(
            path: 'recipe/:recipeId',
            name: 'recipe',
            pageBuilder: (context, state) => NoTransitionPage(child: RecipeDetail(recipeId: state.params['recipeId']!)),
          ),
        ]
      )
    ]
  );
}