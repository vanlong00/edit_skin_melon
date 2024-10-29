// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:flutter/material.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/community_upload/blocs/community_upload_bloc.dart'
    as _i11;
import '../../features/detail/blocs/detail_bloc.dart' as _i12;
import '../../features/home/blocs/community/community_melon_mods_bloc.dart'
    as _i15;
import '../../features/home/blocs/home/melon_mods_bloc.dart' as _i16;
import '../../features/home/blocs/workspace/workspace_bloc.dart' as _i9;
import '../../features/search/blocs/search_bloc.dart' as _i13;
import '../../features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart'
    as _i6;
import '../../features/skin_editor/blocs/skin_item/skin_item_bloc.dart' as _i7;
import '../../features/skin_editor/blocs/skin_part/skin_part_bloc.dart' as _i8;
import '../../services/api_service.dart' as _i10;
import '../../services/download_service.dart' as _i4;
import '../../services/pre_init_data.dart' as _i17;
import '../utils/helpers/version_data_helper.dart' as _i14;
import 'register_module.dart' as _i18;

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
    gh.lazySingleton<_i4.DownloadService>(
        () => _i4.DownloadService(gh<_i3.Dio>()));
    gh.lazySingleton<_i5.GlobalKey<_i5.NavigatorState>>(
        () => registerModule.navigatorKey());
    gh.factory<_i6.SkinEditorBloc>(() => _i6.SkinEditorBloc());
    gh.lazySingleton<_i7.SkinItemBloc>(() => _i7.SkinItemBloc());
    gh.factory<_i8.SkinPartBloc>(() => _i8.SkinPartBloc());
    gh.lazySingleton<_i9.WorkspaceBloc>(() => _i9.WorkspaceBloc());
    gh.lazySingleton<_i10.ApiService>(() => _i10.ApiService(gh<_i3.Dio>()));
    gh.factory<_i11.CommunityUploadBloc>(
        () => _i11.CommunityUploadBloc(gh<_i10.ApiService>()));
    gh.factory<_i12.DetailBloc>(
        () => _i12.DetailBloc(gh<_i4.DownloadService>()));
    gh.lazySingleton<_i13.SearchBloc>(
        () => _i13.SearchBloc(gh<_i10.ApiService>()));
    gh.lazySingleton<_i14.VersionDataHelper>(
        () => _i14.VersionDataHelper(gh<_i10.ApiService>()));
    gh.factory<_i15.CommunityMelonModsBloc>(() => _i15.CommunityMelonModsBloc(
          gh<_i10.ApiService>(),
          gh<_i14.VersionDataHelper>(),
        ));
    gh.lazySingleton<_i16.MelonModsBloc>(() => _i16.MelonModsBloc(
          gh<_i10.ApiService>(),
          gh<_i14.VersionDataHelper>(),
        ));
    gh.lazySingleton<_i17.PreInitData>(
        () => _i17.PreInitData(gh<_i14.VersionDataHelper>()));
    return this;
  }
}

class _$RegisterModule extends _i18.RegisterModule {}
