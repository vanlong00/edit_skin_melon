part of 'melon_mods_bloc.dart';

abstract class MelonModsState extends Equatable {
  const MelonModsState();
}

final class MelonModsInitial extends MelonModsState {
  @override
  List<Object> get props => [];
}

final class MelonModsLoading extends MelonModsState {
  @override
  List<Object> get props => [];
}

final class MelonModsComplete extends MelonModsState {
  final List<MelonModel> items;

  const MelonModsComplete(this.items);

  @override
  List<Object> get props => [items];
}

final class MelonModsError extends MelonModsComplete {
  final FailureException failure;

  MelonModsError(this.failure) : super([]);

  @override
  List<Object> get props => [failure];
}

final class MelonModsRefreshComplete extends MelonModsComplete {
  const MelonModsRefreshComplete(List<MelonModel> items) : super(items);
}

final class MelonMOdsRefreshError extends MelonModsComplete {
  const MelonMOdsRefreshError(List<MelonModel> items) : super(items);
}

final class MelonModsLoadNoMoreData extends MelonModsComplete {
  const MelonModsLoadNoMoreData(List<MelonModel> items) : super(items);
}

final class MelonModsLoadMoreComplete extends MelonModsComplete {
  const MelonModsLoadMoreComplete(List<MelonModel> items) : super(items);
}

final class MelonModsLoadMoreLoading extends MelonModsComplete {
  const MelonModsLoadMoreLoading(List<MelonModel> items) : super(items);
}

final class MelonModsLoadMoreError extends MelonModsComplete {
  const MelonModsLoadMoreError(List<MelonModel> items) : super(items);
}
