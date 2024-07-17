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

class SkinItemLoaded extends SkinItemState {
  final Map<String, Map<String, List<String>>> skinsModel;
  final int indexPart;

  const SkinItemLoaded({required this.skinsModel, this.indexPart = 0});

  SkinItemLoaded copyWith({
    Map<String, Map<String, List<String>>>? skinsModel,
    int? indexPart,
  }) {
    return SkinItemLoaded(
      skinsModel: skinsModel ?? this.skinsModel,
      indexPart: indexPart ?? this.indexPart,
    );
  }

  @override
  List<Object> get props => [skinsModel, indexPart];
}
