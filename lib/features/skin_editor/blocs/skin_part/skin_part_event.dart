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
