// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/skin_editor/blocs/skin_editor/skin_editor_bloc.dart'
    as _i4;
import '../../features/skin_editor/blocs/skin_item/skin_item_bloc.dart' as _i5;
import '../../features/skin_editor/blocs/skin_part/skin_part_bloc.dart' as _i6;
import 'register_module.dart' as _i7;

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
    gh.singleton<_i3.GlobalKey<_i3.NavigatorState>>(
        () => registerModule.navigatorKey());
    gh.factory<_i4.SkinEditorBloc>(() => _i4.SkinEditorBloc());
    gh.lazySingleton<_i5.SkinItemBloc>(() => _i5.SkinItemBloc());
    gh.factory<_i6.SkinPartBloc>(() => _i6.SkinPartBloc());
    return this;
  }
}

class _$RegisterModule extends _i7.RegisterModule {}
