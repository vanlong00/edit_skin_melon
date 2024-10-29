import 'dart:async';

import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'search_event.dart';
import 'search_state.dart';

@lazySingleton
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService _apiService;
  final int _limit = 30;

  SearchBloc(this._apiService) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<List<MelonModel>> _search(String query) async {
    final List<MelonModel> results = [];
    bool isLastPage = false;
    int page = 0;

    while (!isLastPage) {
      final response = await _apiService.getRequest(
        ApiEndpoints.endPointSearchCategory,
        queryParameters: {
          's': query,
          'limit': _limit,
          'page': page,
          'order_by': 'newst',
          'order_type': 'DESC',
          'type': 0,
          'is_verify': true,
          'isHide': false,
        },
      );

      final melonsFromNetwork = response.map<MelonModel>((index) => MelonModel.fromJson(index)).toList();

      results.addAll(melonsFromNetwork);
      isLastPage = checkIsLastPage(melonsFromNetwork.length);
      page++;
    }

    return results;
  }

  Future<FutureOr<void>> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      // Simulate a search operation
      final results = await _search(event.query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  bool checkIsLastPage(int lengthData) => lengthData < _limit;
}
