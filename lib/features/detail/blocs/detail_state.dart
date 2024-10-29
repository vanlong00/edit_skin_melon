part of 'detail_bloc.dart';

sealed class DetailState extends Equatable {
  const DetailState();
}

class DetailInitial extends DetailState {
  @override
  List<Object> get props => [];
}

class DetailDownloadLoading extends DetailState {
  @override
  List<Object> get props => [];
}

class DetailDownloadSuccess extends DetailState {
  @override
  List<Object> get props => [];
}

class DetailDownloadFailure extends DetailState {
  final String message;

  const DetailDownloadFailure(this.message);

  @override
  List<Object> get props => [message];
}
