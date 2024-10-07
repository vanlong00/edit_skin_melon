part of 'skin_part_bloc.dart';

sealed class SkinPartEvent extends ReplayEvent with EquatableMixin{
  const SkinPartEvent();
}

class SkinPartEventInitialEvent extends SkinPartEvent {
  final List<Part> parts;

  const SkinPartEventInitialEvent(this.parts);

  @override
  List<Object?> get props => [parts];
}

class SkinPartBlendColorEvent extends SkinPartEvent {
  final Uint8List data;
  final int indexPart;

  const SkinPartBlendColorEvent(this.indexPart, {required this.data});

  @override
  List<Object?> get props => [data];
}

class SkinPartUpdateAvailableModelEvent extends SkinPartEvent {
  final String skinPath;
  final String dataPath;
  final int indexPart;

  const SkinPartUpdateAvailableModelEvent({required this.skinPath, required this.dataPath, required this.indexPart});

  @override
  List<Object?> get props => [skinPath, dataPath, indexPart];
}