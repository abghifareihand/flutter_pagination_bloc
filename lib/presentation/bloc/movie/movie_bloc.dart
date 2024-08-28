import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/data/datasources/movie_remote_datasource.dart';
import 'package:flutter_pagination_bloc/data/models/movie_model.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  int page = 1;
  bool hasMore = true;
  List<MovieModel> movies = [];
  MovieBloc() : super(MovieInitial()) {
    on<GetMovieEvent>((event, emit) async {
      final result = await MovieRemoteDatasource().fetchMovie(page);
      result.fold(
        (error) => emit(MovieError(error)),
        (data) {
          print('Get Movie: ${data.length}');
          print('Page: $page');
          hasMore = data.isNotEmpty;
          movies.addAll(data);
          page++;
          print('Total Movies: ${movies.length}');
          emit(MovieLoaded(movies, hasMore));
        },
      );
    });
  }
}
