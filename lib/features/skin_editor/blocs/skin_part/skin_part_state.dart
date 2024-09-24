part of 'skin_part_bloc.dart';

class SkinPartState extends Equatable {
  final List<Part>? parts;

  const SkinPartState({this.parts = const []});

  SkinPartState copyWith({
    List<Part>? parts,
  }) {
    return SkinPartState(
      parts: parts ?? this.parts,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [parts];
}
