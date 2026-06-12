part of '../cubits/search_cubit.dart';

enum Status { idle, loading, success, empty, error }

class SearchState {
  final Status status;
  final List<RecipeModel> results;
  final String text;

  const SearchState({
    required this.status,
    this.results = const [],
    required this.text,
  });

  SearchState.idle() : this(status: Status.idle, text: '');

  SearchState.loading() : this(status: Status.loading, text: '');

  SearchState.success(List<RecipeModel> data)
    : this(status: Status.success, results: data, text: '');

  SearchState.empty() : this(status: Status.empty, text: '');

  SearchState.error(String text) : this(status: Status.error, text: text);
}
