import 'dart:async';

import 'package:edit_skin_melon/core/utils/api_endpoints.dart';
import 'package:edit_skin_melon/core/utils/helpers/version_data_helper.dart';
import 'package:edit_skin_melon/features/home/models/melon_model.dart';
import 'package:edit_skin_melon/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'community_melon_mods_event.dart';
part 'community_melon_mods_state.dart';

@injectable
class CommunityMelonModsBloc extends Bloc<CommunityMelonModsEvent, CommunityMelonModsState> {
  final ApiService _apiService;
  final VersionDataHelper _versionDataHelper;
  final int _limit = 30;
  
  int _page = 0;
  bool _isLastPage = false;

  CommunityMelonModsBloc(
    this._apiService,
    this._versionDataHelper,
  ) : super(CommunityMelonModsInitial()) {
    on<CommunityMelonModsInitialize>(_onCommunityMelonModsInitialize);
    on<CommunityMelonModsRefresh>(_onCommunityMelonModsRefresh);
    on<CommunityMelonModsLoadMore>(_onCommunityMelonModsLoadMore);
  }

  Future<void> _onCommunityMelonModsInitialize(
      CommunityMelonModsInitialize event, Emitter<CommunityMelonModsState> emit) async {
    emit(CommunityMelonModsLoading());
    try {
      final listMods = await _fetchModDatas();
      emit(CommunityMelonModsComplete(listMods));
    } on FailureException catch (e) {
      if (isFirstPage) {
        // emit state error when first page
        emit(CommunityMelonModsError(e));
      } else {
        // emit state error when load more
        emit(CommunityMelonModsLoadNoMoreData((state as CommunityMelonModsComplete).items));
      }
    }
  }

  bool get isFirstPage => _page == 0;

  FutureOr<void> _onCommunityMelonModsLoadMore(
      CommunityMelonModsLoadMore event, Emitter<CommunityMelonModsState> emit) async {
    emit(CommunityMelonModsLoadMoreLoading((state as CommunityMelonModsComplete).items));

    if (_isLastPage) {
      // Todo: emit state is lastPage
      emit(CommunityMelonModsLoadNoMoreData((state as CommunityMelonModsComplete).items));
    } else {
      try {
        final currentItem = (state as CommunityMelonModsComplete).items;

        final items = await _fetchModDatas();

        currentItem.addAll(items);

        emit(CommunityMelonModsLoadMoreComplete(currentItem));
      } catch (e) {
        emit(CommunityMelonModsLoadMoreError((state as CommunityMelonModsComplete).items));
      }
    }
  }

  Future<FutureOr<void>> _onCommunityMelonModsRefresh(
      CommunityMelonModsRefresh event, Emitter<CommunityMelonModsState> emit) async {
    emit(CommunityMelonModsLoadMoreLoading((state as CommunityMelonModsComplete).items));

    _page = 0;
    _isLastPage = false;

    try {
      await _versionDataHelper.checkDataServer();

      final items = await _fetchModDatas();

      emit(CommunityMelonModsRefreshComplete(items));
    } catch (e) {
      emit(CommunityMelonModsRefreshError((state as CommunityMelonModsComplete).items));
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
        'type': 1,
        'is_verify': true,
        'isHide': false,
        'isLivingSkin': true
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