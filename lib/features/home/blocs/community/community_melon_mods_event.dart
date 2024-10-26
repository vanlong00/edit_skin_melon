part of 'community_melon_mods_bloc.dart';

sealed class CommunityMelonModsEvent extends Equatable {
  const CommunityMelonModsEvent();
}

class CommunityMelonModsInitialize extends CommunityMelonModsEvent {
  @override
  List<Object?> get props => [];
}

class CommunityMelonModsRefresh extends CommunityMelonModsEvent {
  @override
  List<Object?> get props => [];
}

class CommunityMelonModsLoadMore extends CommunityMelonModsEvent {
  @override
  List<Object?> get props => [];
}