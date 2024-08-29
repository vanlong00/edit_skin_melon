part of 'skin_item_bloc.dart';

abstract class SkinItemEvent extends Equatable {
  const SkinItemEvent();
}

class SkinItemInitData extends SkinItemEvent {
  @override
  List<Object> get props => [];
}

class SkinItemSelect extends SkinItemEvent {
  final int indexPart;

  const SkinItemSelect({required this.indexPart});

  @override
  List<Object> get props => [indexPart];
}
