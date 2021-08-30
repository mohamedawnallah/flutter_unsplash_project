import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photos_app/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<Photo> photos;
  final int currentIndex;
  const PhotoViewerScreen(
      {Key? key, required this.photos, required this.currentIndex})
      : super(key: key);

  @override
  _PhotoViewerScreenState createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(Icons.arrow_back_ios)),
        elevation: 0,
      ),
      body: PageView.builder(
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            final photo = widget.photos[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag:Key('$index _ ${photo.id}'),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: 300.0,
                    imageUrl: photo.url,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Center(
                      child:
                          const Icon(Icons.error, color: Colors.red, size: 50.0),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${index + 1}/${widget.photos.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        photo.description,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16.0,
                            backgroundColor: Colors.grey[100],
                            backgroundImage: CachedNetworkImageProvider(
                                photo.user.profileImageUrl),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            onTap: () async {
                              final url = photo.user.profileUrl;
                              print('launching');
                              try {
                                await canLaunch(url)
                                    ? await launch(url)
                                    : throw Exception('Could not launch $url');
                                print('succcess');
                              } on Exception catch (e, s) {
                                print('failure:\n$e\n$s');
                              }
                            },
                            child: Text(
                              photo.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          controller: _pageController),
    );
  }
}
