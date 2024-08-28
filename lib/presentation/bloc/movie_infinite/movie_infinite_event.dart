part of 'movie_infinite_bloc.dart';

sealed class MovieInfiniteEvent {}

final class GetMovieInfiniteEvent extends MovieInfiniteEvent {
  final int page;

  GetMovieInfiniteEvent({required this.page});
}
