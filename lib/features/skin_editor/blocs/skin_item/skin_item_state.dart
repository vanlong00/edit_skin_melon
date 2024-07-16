part of 'skin_item_bloc.dart';

abstract class SkinItemState extends Equatable {
  const SkinItemState();
}

class SkinItemInitial extends SkinItemState {
  @override
  List<Object> get props => [];
}

class SkinItemLoading extends SkinItemState {
  @override
  List<Object> get props => [];
}
