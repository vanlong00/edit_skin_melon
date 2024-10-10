part of 'melon_mods_bloc.dart';

sealed class MelonModsEvent extends Equatable {
  const MelonModsEvent();
}

class MelonModsInitialize extends MelonModsEvent {
  @override
  List<Object?> get props => [];
}

class MelonModsRefresh extends MelonModsEvent {
  @override
  List<Object?> get props => [];
}

class MelonModsLoadMore extends MelonModsEvent {
  @override
  List<Object?> get props => [];
}
