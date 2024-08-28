import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/movie_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/movie_model.dart';
import '../bloc/movie_infinite/movie_infinite_bloc.dart';

class MovieInfinitePage extends StatefulWidget {
  const MovieInfinitePage({super.key});

  @override
  State<MovieInfinitePage> createState() => _MovieInfinitePageState();
}

class _MovieInfinitePageState extends State<MovieInfinitePage> {
  final PagingController<int, MovieModel> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      context.read<MovieInfiniteBloc>().add(GetMovieInfiniteEvent(page: pageKey));
    });

    // You can handle the state changes here to update the PagingController
    context.read<MovieInfiniteBloc>().stream.listen((state) {
      if (state is MovieInfiniteLoaded) {
        if (state.hasMore) {
          _pagingController.appendPage(state.movie, _pagingController.nextPageKey! + 1);
        } else {
          _pagingController.appendLastPage(state.movie);
        }
      }
      if (state is MovieInfiniteError) {
        _pagingController.error = state.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Pagination Infinite Page'),
      ),
      body: PagedListView.separated(
        padding: const EdgeInsets.all(16.0),
        pagingController: _pagingController,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        builderDelegate: PagedChildBuilderDelegate<MovieModel>(
          itemBuilder: (context, movie, index) => MovieCard(
            movie: movie,
            id: index,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
