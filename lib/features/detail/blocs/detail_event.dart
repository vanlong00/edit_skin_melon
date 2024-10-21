part of 'detail_bloc.dart';

sealed class DetailEvent extends Equatable {
  const DetailEvent();
}

class DetailStartedDownload extends DetailEvent {
  final String? linkDownload;

  const DetailStartedDownload(this.linkDownload);

  @override
  List<Object?> get props => [linkDownload];
}