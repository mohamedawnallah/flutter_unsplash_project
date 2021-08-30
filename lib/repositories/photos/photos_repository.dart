import 'package:photos_app/models/failure_model.dart';
import 'package:photos_app/models/photo_model.dart';
import 'package:photos_app/repositories/reepositories.dart';
import 'package:http/http.dart' as http;
import 'package:photos_app/.env.dart';
import 'dart:convert';

class PhotosRepository extends BasePhotoRepository {
  static const _unsplashBaseUrl = 'https://api.unsplash.com';
  static const int numberPerPage = 10;
  final http.Client _httpClient;
  PhotosRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();
  @override
  void dispose() {
    // TODO: implement dispose
    //Dispose Http Client
    _httpClient.close();
  }

  @override
  Future<List<Photo>> searchPhotos(
      {required String query, int page = 1}) async {
    final url =
        '$_unsplashBaseUrl/search/photos?client_id=$unsplashApiKey&page=$page&per_page=$numberPerPage&query=$query';
    final response = await _httpClient.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'];
      final List<Photo> photos =
          results.map<Photo>((e) => Photo.fromMap(e)).toList();
      return photos;
    }
    throw Failure();
  }
}
