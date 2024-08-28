import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/data/models/user_response_model.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/user_card.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/user_card_shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_pagination_bloc/presentation/bloc/user/user_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Pagination Infinite Page'),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded && !state.hasMore) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No more data available'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          bloc: context.read<UserBloc>()..add(GetUserEvent(page: 1)),
          builder: (context, state) {
            if (state is UserInitial) {
              return const Center(
                child: SpinKitFadingCircle(color: Colors.redAccent),
              );
            }

            if (state is UserError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is UserLoaded) {
              final pagingController = context.read<UserBloc>().pagingController;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(GetUserEvent(page: 1));
                },
                child: PagedListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  pagingController: pagingController,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  builderDelegate: PagedChildBuilderDelegate<UserResponseModel>(
                    itemBuilder: (context, user, index) => UserCard(
                      user: user,
                      id: index,
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const UserCardShimmer(),
                    newPageProgressIndicatorBuilder: (_) => const UserCardShimmer(),
                  ),
                ),
              );
            }

            return const Center(
              child: SpinKitFadingCircle(color: Colors.blue),
            );
          },
        ),
      ),
    );
  }
}
