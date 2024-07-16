import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/functions/any_functions.dart';

part 'skin_item_event.dart';

part 'skin_item_state.dart';

@injectable
class SkinItemBloc extends Bloc<SkinItemEvent, SkinItemState> {
  Map<String, Map<String, List<String>>> skinsModel = {
    "head": {},
    "body1": {},
    "body2": {},
    "body3": {},
    "leg_left1": {},
    "leg_left2": {},
    "leg_left3": {},
    "leg_right1": {},
    "leg_right2": {},
    "leg_right3": {},
    "arm_left1": {},
    "arm_left2": {},
    "arm_right1": {},
    "arm_right2": {},
  };

  SkinItemBloc() : super(SkinItemInitial()) {
    on<SkinItemInitData>(_onSkinItemInitData);
  }

  Future<FutureOr<void>> _onSkinItemInitData(SkinItemInitData event, Emitter<SkinItemState> emit) async {
    emit(SkinItemLoading());

    final manifestMap = await AnyFunction.loadModsAsset();
    final cateSkins = skinsModel.keys.toList();

    for (var cate in cateSkins) {
      final skinsData =
          manifestMap.keys.where((key) => key.contains("images/")).where((key) => key.contains("$cate/")).toList();

      final thumbs = skinsData.where((key) => key.contains("thumb/")).toList();
      final datas = skinsData.where((key) => !key.contains("data/")).toList();

      skinsModel[cate]?.addAll({
        "data": thumbs,
        "thumb": datas,
      });
    }

    print(skinsModel);
  }
}
