import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/models/models.dart';
import 'package:photos_app/screens/screens.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;
  final List<Photo> photos;
  final int currentIndex;
  PhotoCard(
      {required this.photo, required this.photos, required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PhotoViewerScreen(
            photos: photos,
            currentIndex: currentIndex,
          ),
        ),
      ),
      child: Hero(
        tag: Key('$currentIndex _ ${photo.id}'),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  photo.url,
                ),
                fit: BoxFit.cover,
              ),
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                )
              ]),
        ),
      ),
    );
  }
}
