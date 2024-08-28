part of 'movie_infinite_bloc.dart';

abstract class MovieInfiniteState {}

final class MovieInfiniteInitial extends MovieInfiniteState {}

final class MovieLoading extends MovieInfiniteState {}

final class MovieInfiniteLoaded extends MovieInfiniteState {
  final List<MovieModel> movie;
  final bool hasMore;
  MovieInfiniteLoaded(this.movie, this.hasMore);
}

final class MovieInfiniteError extends MovieInfiniteState {
  final String message;

  MovieInfiniteError(this.message);
}
