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
  final List<Melon> items;

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

final class MelonModsLoadNoMoreData extends MelonModsComplete {
  const MelonModsLoadNoMoreData(List<Melon> items) : super(items);
}

final class MelonModsRefreshComplete extends MelonModsComplete {
  const MelonModsRefreshComplete(List<Melon> items) : super(items);
}
