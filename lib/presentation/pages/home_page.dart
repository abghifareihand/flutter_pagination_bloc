import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/user_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_pagination_bloc/presentation/bloc/user/user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && context.read<UserBloc>().hasMore) {
      debugPrint('Fetching new data...');
      context.read<UserBloc>().add(GetUserEvent());
    }
  }

  @override
  void initState() {
    context.read<UserBloc>().add(GetUserEvent());
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
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          /// loaded state
          if (state is UserLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              controller: _scrollController,
              itemCount: context.read<UserBloc>().hasMore
                  ? state.userResponse.length + 1
                  : state.userResponse.length,
              itemBuilder: (context, index) {
                if (index < state.userResponse.length) {
                  final user = state.userResponse[index];
                  return UserCard(user: user);
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
          if (state is UserError) {
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
