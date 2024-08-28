import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/models/movie_model.dart';

part 'movie_infinite_event.dart';
part 'movie_infinite_state.dart';

class MovieInfiniteBloc extends Bloc<MovieInfiniteEvent, MovieInfiniteState> {
  MovieInfiniteBloc() : super(MovieInfiniteInitial()) {
    on<GetMovieInfiniteEvent>((event, emit) async {
      final result = await MovieRemoteDatasource().getMovie(event.page);
      result.fold(
        (error) => emit(MovieInfiniteError(error)),
        (data) {
          print('Get Movie: ${data.length}');
          emit(MovieInfiniteLoaded(data, data.isNotEmpty));
        },
      );
    });
  }
}
