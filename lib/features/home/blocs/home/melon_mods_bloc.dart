import 'dart:async';

import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/core/utils/helpers/version_data_helper.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'melon_mods_event.dart';
part 'melon_mods_state.dart';

@injectable
class MelonModsBloc extends Bloc<MelonModsEvent, MelonModsState> {
  final ApiService _apiService;
  final VersionDataHelper _versionDataHelper;
  final int _limit = 30;
  int _page = 0;
  bool _isLastPage = false;

  MelonModsBloc(
    this._apiService,
    this._versionDataHelper,
  ) : super(MelonModsInitial()) {
    on<MelonModsInitialize>(_onMelonModsInitialize);
    on<MelonModsRefresh>(_onMelonModsRefresh);
    on<MelonModsLoadMore>(_onMelonModsLoadMore);
  }

  Future<void> _onMelonModsInitialize(
      MelonModsInitialize event, Emitter<MelonModsState> emit) async {
    emit(MelonModsLoading());
    try {
      final listMods = await _fetchModDatas();
      emit(MelonModsComplete(listMods));
    } on FailureException catch (e) {
      if (isFirstPage) {
        // emit state error when first page
        emit(MelonModsError(e));
      } else {
        // emit state error when load more
        emit(MelonModsLoadNoMoreData((state as MelonModsComplete).items));
      }
    }
  }

  bool get isFirstPage => _page == 0;

  FutureOr<void> _onMelonModsLoadMore(
      MelonModsLoadMore event, Emitter<MelonModsState> emit) async {
    emit(MelonModsLoadMoreLoading((state as MelonModsComplete).items));

    if (_isLastPage) {
      // Todo: emit state is lastPage
      emit(MelonModsLoadNoMoreData((state as MelonModsComplete).items));
    } else {
      try {
        final currentItem = (state as MelonModsComplete).items;

        final items = await _fetchModDatas();

        currentItem.addAll(items);

        emit(MelonModsLoadMoreComplete(currentItem));
      } catch (e) {
        emit(MelonModsLoadMoreError((state as MelonModsComplete).items));
      }
    }
  }

  Future<FutureOr<void>> _onMelonModsRefresh(
      MelonModsRefresh event, Emitter<MelonModsState> emit) async {
    emit(MelonModsLoadMoreLoading((state as MelonModsComplete).items));

    _page = 0;
    _isLastPage = false;

    try {
      await _versionDataHelper.checkDataServer();

      final items = await _fetchModDatas();

      emit(MelonModsRefreshComplete(items));
    } catch (e) {
      emit(MelonMOdsRefreshError((state as MelonModsComplete).items));
    }
  }

  Future<List<MelonModel>> _fetchModDatas() async {
    final response = await _apiService.getRequest(
      ApiEndpoints.endPointCategory,
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

    final melonsFromNetwork = response
        .map<MelonModel>((index) => MelonModel.fromJson(index))
        .toList();

    _isLastPage = checkIsLastPage(melonsFromNetwork.length);
    _page++;

    return melonsFromNetwork;
  }

  bool checkIsLastPage(int lengthData) => lengthData < _limit;
}
