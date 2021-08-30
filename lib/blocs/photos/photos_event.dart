part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];
  @override
  // TODO: implement stringify
  bool? get stringify => true;
}

class PhotoSearchPhotos extends PhotosEvent {
  final String query;
  const PhotoSearchPhotos({required this.query});
  @override
  // TODO: implement props
  List<Object> get props => [query];
}

class PhotosPaginate extends PhotosEvent{}