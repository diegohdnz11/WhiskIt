import 'package:flutter/material.dart';
import 'package:recipe_test/config/routes/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_test/features/data/repository/favorites_storage.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/favorites_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final favoritesService = await FavoritesService.create();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FavoritesService>(
          create: (context) => favoritesService,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FavoritesCubit>(
            create: (context) =>
                FavoritesCubit(context.read<FavoritesService>()),
          ),
        ],
        child: const RecipeApp(),
      ),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRoute().router;
    return MaterialApp.router(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
