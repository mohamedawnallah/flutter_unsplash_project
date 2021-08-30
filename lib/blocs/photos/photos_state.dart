part of 'photos_bloc.dart';

enum PhotoStatus { inital, loading,paginating,noMorePhotos, loaded, error }

class PhotosState extends Equatable {
  final String query;
  final List<Photo> photos;
  final PhotoStatus status;
  final Failure failure;

  const PhotosState({
    required this.query,
    required this.photos,
    required this.status,
    required this.failure,
  });
  factory PhotosState.initial() {
    return PhotosState(
        query: '', photos: [], status: PhotoStatus.inital, failure: Failure());
  }
  @override
  List<Object> get props => [query, photos, status, failure];
  @override
  // TODO: implement stringify
  bool? get stringify => true;
  PhotosState copyWith(
      {String? query,
      List<Photo>? photos,
      PhotoStatus? status,
      Failure? failure}) {
    return PhotosState(
        query: query ?? this.query,
        photos: photos ?? this.photos,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }
}
