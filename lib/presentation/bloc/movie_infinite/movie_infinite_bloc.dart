import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/datasources/movie_remote_datasource.dart';
import '../../../data/models/movie_model.dart';

part 'movie_infinite_event.dart';
part 'movie_infinite_state.dart';

class MovieInfiniteBloc extends Bloc<MovieInfiniteEvent, MovieInfiniteState> {
  final PagingController<int, MovieModel> pagingController = PagingController(firstPageKey: 1);
  MovieInfiniteBloc() : super(MovieInfiniteInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(GetMovieInfiniteEvent(page: pageKey));
    });
    on<GetMovieInfiniteEvent>((event, emit) async {
      final result = await MovieRemoteDatasource().getMovie(event.page);
      result.fold(
        (error) => emit(MovieInfiniteError(error)),
        (data) {
          final hasMore = data.isNotEmpty;
          if (data.isEmpty) {
            pagingController.appendLastPage([]);
            emit(MovieInfiniteLoaded([], false));
          } else {
            if (hasMore) {
              pagingController.appendPage(data, event.page + 1);
            } else {
              pagingController.appendLastPage(data);
            }
            emit(MovieInfiniteLoaded(data, hasMore));
          }
        },
      );
    });
  }
}
