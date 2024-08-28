import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_pagination_bloc/data/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MovieRemoteDatasource {
  Future<Either<String, List<MovieModel>>> fetchMovie(int page) async {
    const String apiKey = 'api_key=b30ade62125473ece573590a8b799729';
    const String baseUrl = 'https://api.themoviedb.org/3';
    // const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

    final url = '$baseUrl/movie/popular?page=$page&$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final List<MovieModel> movieList = data.map((data) => MovieModel.fromJson(data)).toList();
      return Right(movieList);
    } else {
      return const Left('Failed Get Users');
    }
  }
}
