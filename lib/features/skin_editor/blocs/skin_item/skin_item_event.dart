part of 'skin_item_bloc.dart';

abstract class SkinItemEvent extends Equatable {
  const SkinItemEvent();
}

class SkinItemInitData extends SkinItemEvent {
  final String assetsPath;

  const SkinItemInitData(this.assetsPath);

  @override
  List<Object> get props => [assetsPath];
}
