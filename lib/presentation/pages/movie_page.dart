import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/Movie_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/movie/movie_bloc.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final ScrollController _scrollController = ScrollController();

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      debugPrint('Fetching new data...');
      context.read<MovieBloc>().add(GetMovieEvent());
    }
  }

  @override
  void initState() {
    context.read<MovieBloc>().add(GetMovieEvent());
    super.initState();
    _scrollController.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Pagination Page'),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          /// loaded state
          if (state is MovieLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              controller: _scrollController,
              itemCount: state.hasMore ? state.movie.length + 1 : state.movie.length,
              itemBuilder: (context, index) {
                if (index < state.movie.length) {
                  final movie = state.movie[index];
                  return MovieCard(
                    movie: movie,
                    id: index,
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: SpinKitFadingCircle(
                        size: 30,
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                }
              },
            );
          }

          /// error state
          if (state is MovieError) {
            return Center(
              child: Text(state.message),
            );
          }

          /// initial state
          return const Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
