import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_test/features/presentation/bloc/cubits/search_cubit.dart';
import 'package:recipe_test/features/data/repository/recipe_repo_impl.dart';
import 'package:recipe_test/core/api/recipe_api.dart';
import 'package:recipe_test/features/data/repository/favorites_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchCubit(RecipeRepositoryImpl(RecipeApi(), FavoritesService())),
      child: Builder(
        builder: (BuildContext builderContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "The Recipe Book",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              backgroundColor: Colors.brown[700],
              actions: [
                IconButton(
                  onPressed: () => builderContext.goNamed('favorites'),
                  //go to favorite page
                  icon: Icon(Icons.favorite_border, color: Colors.white),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: text,
                    decoration: InputDecoration(
                      hintText: 'Search Recipe',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => builderContext
                            .read<SearchCubit>()
                            .search(text.text), //search for recipe
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => builderContext
                        .read<SearchCubit>()
                        .search(value), //search for recipe
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case Status.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            ); //circle loading indicator
                          case Status.error:
                            return Center(child: Text(state.text));
                          case Status.empty:
                            return Center(child: Text('No results'));
                          case Status.idle:
                            return Center(
                              child: Text('Type something like "chicken"'),
                            );
                          case Status.success:
                            return ListView.builder(
                              itemCount: state.results.length,
                              itemBuilder: (context, i) {
                                final recipe_review = state.results[i];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        recipe_review.thumbnail,
                                      ),
                                    ),
                                    title: Text(recipe_review.title),
                                    subtitle: Text(
                                      (recipe_review.instructions)
                                          .split('\n')
                                          .first,
                                      maxLines: 2,
                                    ),
                                    //route to recipe page
                                    onTap: () => context.goNamed(
                                      'recipe',
                                      params: {'recipeId': recipe_review.id},
                                      //
                                    ),
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
