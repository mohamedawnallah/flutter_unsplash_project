import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photos_app/repositories/photos/photos_repository.dart';
import 'package:photos_app/screens/screens.dart';

import 'blocs/blocs.dart';

void main() {
  EquatableConfig.stringify = kDebugMode;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhotosRepository(),
      child: BlocProvider(
        create: (context) => PhotosBloc(
          photosRepository: context.read<PhotosRepository>(),
        )..add(
            PhotoSearchPhotos(query: 'programming'),
          ),
        child: MaterialApp(
          title: 'Flutter Photos App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const PhotosScreen(),
        ),
      ),
    );
  }
}
