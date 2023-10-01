import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/params/params.dart';
import '../../../../core/constants/constants.dart';
import '../models/pokemon_image_model.dart';

abstract class PokemonImageRemoteDataSource {
  Future<PokemonImageModel> getPokemonImage(
      {required PokemonImageParams pokemonImageParams});
}

class PokemonImageRemoteDataSourceImpl implements PokemonImageRemoteDataSource {
  final Dio dio;

  PokemonImageRemoteDataSourceImpl({required this.dio});

  @override
  Future<PokemonImageModel> getPokemonImage(
      {required PokemonImageParams pokemonImageParams}) async {
    // Get the directory where we can save the image
    Directory directory = await getApplicationDocumentsDirectory();
    try {
      directory.deleteSync(
          recursive: true); // Delete all the files in the directory
    } on PathAccessException {
      print("PathAccessException");
    }
    final String pathFile = '${directory.path}/${pokemonImageParams.name}.png';

    final response = await dio.download(
      pokemonImageParams.imageUrl,
      pathFile,
    );

    if (response.statusCode == 200) {
      // It works!
      return PokemonImageModel.fromJson(json: {kPath: pathFile});
    } else {
      throw ServerException();
    }
  }
}
