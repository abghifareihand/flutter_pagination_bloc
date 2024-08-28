part of 'movie_bloc.dart';

abstract class MovieState {}

final class MovieInitial extends MovieState {}

final class MovieLoading extends MovieState {}

final class MovieLoaded extends MovieState {
  final List<MovieModel> movie;
  final bool hasMore;
  MovieLoaded(this.movie, this.hasMore);
}

final class MovieError extends MovieState {
  final String message;

  MovieError(this.message);
}
