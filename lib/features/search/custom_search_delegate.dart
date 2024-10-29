import 'package:edit_skin_melon/features/home/widgets/melon_widget.dart';
import 'package:edit_skin_melon/features/search/blocs/search_bloc.dart';
import 'package:edit_skin_melon/features/search/blocs/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'blocs/search_event.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final SearchBloc searchBloc;

  CustomSearchDelegate({required this.searchBloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No items available',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(SearchQueryChanged(query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          if (state.results.isEmpty) {
            return _buildEmptyWidget();
          }

          return MasonryGridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              final item = state.results[index];
              return MelonWidget.home(
                item: item,
                isMoreSpace: index % 2 != 0,
              );
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No results'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text(
        'Search for items',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
