import 'dart:async';

import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/features/home/models/melon.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'melon_mods_event.dart';
part 'melon_mods_state.dart';

@injectable
class MelonModsBloc extends Bloc<MelonModsEvent, MelonModsState> {
  final ApiService _apiService;
  final int _limit = 30;
  final String _cate = 'Living';
  int _page = 0;
  bool _isLastPage = false;

  MelonModsBloc(this._apiService) : super(MelonModsInitial()) {
    on<MelonModsInitialize>(_onMelonModsInitialize);
    on<MelonModsRefresh>(_onMelonModsRefresh);
    on<MelonModsLoadMore>(_onMelonModsLoadMore);
  }

  Future<void> _onMelonModsInitialize(MelonModsInitialize event, Emitter<MelonModsState> emit) async {
    emit(MelonModsLoading());
    await Future.delayed(const Duration(seconds: 6));
    try {
      final listMods = await _fetchModDatas();
      emit(MelonModsComplete(listMods));
    } on FailureException catch (e) {
      emit(MelonModsError(e));
    }
  }

  FutureOr<void> _onMelonModsLoadMore(MelonModsLoadMore event, Emitter<MelonModsState> emit) {}

  FutureOr<void> _onMelonModsRefresh(MelonModsRefresh event, Emitter<MelonModsState> emit) {
    // if (state is MelonModsComplete) {
    //   final items = (state as MelonModsComplete).items;
    //   items.clear();
    //   emit(MelonModsRefreshComplete(items));
    // }
    // _page = 0;
    // add(MelonModsInitialize());
  }

  Future<List<Melon>> _fetchModDatas() async {
    final response = await _apiService.getRequest(
      '${ApiEndpoints.endPointCategory}/',
      queryParameters: {
        'limit': _limit,
        'page': _page,
        'order_by': 'newst',
        'order_type': 'DESC',
        'type': 0,
        'is_verify': true,
        'isHide': false,
      },
    );

    final melonsFromNetwork = response.map<Melon>((index) => Melon.fromJson(index)).toList();

    _isLastPage = checkIsLastPage(melonsFromNetwork.length);
    _page++;

    return melonsFromNetwork;
  }

  bool checkIsLastPage(int lengthData) => lengthData < _limit;
}
