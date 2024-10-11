// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/home/bloc/home/melon_mods_bloc.dart' as _i10;
import '../../features/home/bloc/workspace/workspace_bloc.dart' as _i8;
import '../../features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart'
    as _i5;
import '../../features/skin_editor/blocs/skin_item/skin_item_bloc.dart' as _i6;
import '../../features/skin_editor/blocs/skin_part/skin_part_bloc.dart' as _i7;
import '../../services/api_service.dart' as _i9;
import '../../services/pre_init_data.dart' as _i11;
import 'register_module.dart' as _i12;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.Dio>(() => registerModule.dio());
    gh.lazySingleton<_i4.GlobalKey<_i4.NavigatorState>>(
        () => registerModule.navigatorKey());
    gh.factory<_i5.SkinEditorBloc>(() => _i5.SkinEditorBloc());
    gh.lazySingleton<_i6.SkinItemBloc>(() => _i6.SkinItemBloc());
    gh.factory<_i7.SkinPartBloc>(() => _i7.SkinPartBloc());
    gh.lazySingleton<_i8.WorkspaceBloc>(() => _i8.WorkspaceBloc());
    gh.lazySingleton<_i9.ApiService>(() => _i9.ApiService(gh<_i3.Dio>()));
    gh.factory<_i10.MelonModsBloc>(
        () => _i10.MelonModsBloc(gh<_i9.ApiService>()));
    gh.lazySingleton<_i11.PreInitData>(
        () => _i11.PreInitData(gh<_i9.ApiService>()));
    return this;
  }
}

class _$RegisterModule extends _i12.RegisterModule {}
