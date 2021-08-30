import 'package:photos_app/repositories/reepositories.dart';
import 'package:photos_app/models/models.dart';
//Dipose Network Request + search Photos
abstract class BasePhotoRepository extends BaseRepository {
  Future<List<Photo>> searchPhotos({required String query, int page});
}
