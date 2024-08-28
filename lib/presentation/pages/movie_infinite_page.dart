import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/movie_model.dart';
import '../bloc/movie_infinite/movie_infinite_bloc.dart';
import '../widgets/movie_card.dart';

class MovieInfinitePage extends StatelessWidget {
  const MovieInfinitePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Pagination Infinite Page'),
      ),
      body: BlocBuilder<MovieInfiniteBloc, MovieInfiniteState>(
        bloc: context.read<MovieInfiniteBloc>()..add(GetMovieInfiniteEvent(page: 1)),
        builder: (context, state) {
          if (state is MovieInfiniteInitial) {
            return const Center(
              child: SpinKitFadingCircle(color: Colors.redAccent),
            );
          }

          if (state is MovieInfiniteError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is MovieInfiniteLoaded) {
            final pagingController = context.read<MovieInfiniteBloc>().pagingController;

            return PagedListView.separated(
              padding: const EdgeInsets.all(16.0),
              pagingController: pagingController,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              builderDelegate: PagedChildBuilderDelegate<MovieModel>(
                itemBuilder: (context, movie, index) => MovieCard(
                  movie: movie,
                  id: index,
                ),
                firstPageProgressIndicatorBuilder: (_) => _buildShimmer(),
                newPageProgressIndicatorBuilder: (_) => _buildShimmer(),
              ),
            );
          }

          return const Center(
            child: SpinKitFadingCircle(color: Colors.blue),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 1.0,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Placeholder for image
              Container(
                width: 100.0,
                height: 150.0,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              // Placeholder for text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100.0,
                      height: 14.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
