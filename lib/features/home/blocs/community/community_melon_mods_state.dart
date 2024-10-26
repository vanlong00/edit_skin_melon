part of 'community_melon_mods_bloc.dart';

abstract class CommunityMelonModsState extends Equatable {
  const CommunityMelonModsState();
}

final class CommunityMelonModsInitial extends CommunityMelonModsState {
  @override
  List<Object> get props => [];
}

final class CommunityMelonModsLoading extends CommunityMelonModsState {
  @override
  List<Object> get props => [];
}

final class CommunityMelonModsComplete extends CommunityMelonModsState {
  final List<MelonModel> items;

  const CommunityMelonModsComplete(this.items);

  @override
  List<Object> get props => [items];
}

final class CommunityMelonModsError extends CommunityMelonModsComplete {
  final FailureException failure;

  CommunityMelonModsError(this.failure) : super([]);

  @override
  List<Object> get props => [failure];
}

final class CommunityMelonModsRefreshComplete extends CommunityMelonModsComplete {
  const CommunityMelonModsRefreshComplete(List<MelonModel> items) : super(items);
}

final class CommunityMelonModsRefreshError extends CommunityMelonModsComplete {
  const CommunityMelonModsRefreshError(List<MelonModel> items) : super(items);
}

final class CommunityMelonModsLoadNoMoreData extends CommunityMelonModsComplete {
  const CommunityMelonModsLoadNoMoreData(List<MelonModel> items) : super(items);
}

final class CommunityMelonModsLoadMoreComplete extends CommunityMelonModsComplete {
  const CommunityMelonModsLoadMoreComplete(List<MelonModel> items) : super(items);
}

final class CommunityMelonModsLoadMoreLoading extends CommunityMelonModsComplete {
  const CommunityMelonModsLoadMoreLoading(List<MelonModel> items) : super(items);
}

final class CommunityMelonModsLoadMoreError extends CommunityMelonModsComplete {
  const CommunityMelonModsLoadMoreError(List<MelonModel> items) : super(items);
}