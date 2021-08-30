import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_app/blocs/photos/photos_bloc.dart';
import 'package:photos_app/models/models.dart';
import 'package:photos_app/repositories/reepositories.dart';
import 'package:photos_app/widgets/widgets.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final PhotosRepository photosRepository = PhotosRepository();
  late ScrollController _scrollController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    photosRepository.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            context.read<PhotosBloc>().state.status != PhotoStatus.paginating) {
          context.read<PhotosBloc>().add(PhotosPaginate());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Photos Flutter App"),
        ),
        body: BlocConsumer<PhotosBloc, PhotosState>(
          listener: (context, state) {
            if (state.status == PhotoStatus.paginating) {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text("Loading more photos..."),
                duration: Duration(seconds: 1),
                backgroundColor: Colors.green,
              ));
            } else if (state.status == PhotoStatus.noMorePhotos) {
              Scaffold.of(context).hideCurrentSnackBar();

              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text("No more photos..."),
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 1500),
              ));
            } else if (state.status == PhotoStatus.error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Search Error"),
                  content: Text(state.failure.message),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK"))
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          context
                              .read<PhotosBloc>()
                              .add(PhotoSearchPhotos(query: value.trim()));
                        }
                      },
                    ),
                    Expanded(
                        child: state.photos.isNotEmpty
                            ? GridView.builder(
                                padding: const EdgeInsets.all(20),
                                controller: _scrollController,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: state.photos.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final photo = state.photos[index];
                                  return PhotoCard(
                                    photo: photo,
                                    currentIndex: index,
                                    photos: state.photos,
                                  );
                                })
                            : Center(
                                child: Text("No results"),
                              )),
                  ],
                ),
                if (state.status == PhotoStatus.loading)
                  CircularProgressIndicator()
              ],
            );
          },
        ),
      ),
    );
  }
}
