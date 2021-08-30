import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:photos_app/blocs/blocs.dart';
import 'package:photos_app/models/models.dart';
import 'package:photos_app/repositories/reepositories.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository _photosRepository;

  PhotosBloc({required PhotosRepository photosRepository})
      : this._photosRepository = photosRepository,
        super(PhotosState.initial());
  @override
  Future<void> close() {
    // TODO: implement close
    _photosRepository.dispose();
    return super.close();
  }

//Generator Function as it uses yield
  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is PhotoSearchPhotos) {
      yield* _mapPhotosSearchPhotosToState(event);
    } else if (event is PhotosPaginate) {
      yield* _mapPhotosPaginateToState();
    }
  }

//async ->gives future
//async* -> gives stream
  Stream<PhotosState> _mapPhotosSearchPhotosToState(
    PhotoSearchPhotos event,
  ) async* {
    yield state.copyWith(
      query: event.query,
      status: PhotoStatus.loading,
    );
    try {
      final photos = await _photosRepository.searchPhotos(query: event.query);
      yield state.copyWith(
        photos: photos,
        status: PhotoStatus.loaded,
      );
    } catch (err) {
      print(err);
      yield state.copyWith(
        failure: Failure(
            message: "Something Went wrong! Please try different search"),
        status: PhotoStatus.error,
      );
    }
  }

  Stream<PhotosState> _mapPhotosPaginateToState() async* {
    yield state.copyWith(status: PhotoStatus.paginating);
    //Create A copy of photos
    final photos = List<Photo>.from(state.photos);
    List<Photo> nextPhotos = [];
    //10>=10 Completed First Page
    if (photos.length >= PhotosRepository.numberPerPage) {
      nextPhotos = await PhotosRepository().searchPhotos(
          query: state.query,
          page: state.photos.length ~/ PhotosRepository.numberPerPage + 1);
    }
    yield state.copyWith(
        photos: photos..addAll(nextPhotos),
        status: nextPhotos.isNotEmpty
            ? PhotoStatus.loaded
            : PhotoStatus.noMorePhotos);
  }
}
