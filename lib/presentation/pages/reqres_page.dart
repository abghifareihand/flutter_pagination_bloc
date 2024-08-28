import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/widgets/reqres_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/reqres/reqres_bloc.dart';

class ReqresPage extends StatefulWidget {
  const ReqresPage({super.key});

  @override
  State<ReqresPage> createState() => _ReqresPageState();
}

class _ReqresPageState extends State<ReqresPage> {
  final ScrollController _scrollController = ScrollController();

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      debugPrint('Fetching new data...');
      context.read<ReqresBloc>().add(GetReqresEvent());
    }
  }

  @override
  void initState() {
    context.read<ReqresBloc>().add(GetReqresEvent());
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
      body: BlocBuilder<ReqresBloc, ReqresState>(
        builder: (context, state) {
          /// loaded state
          if (state is ReqresLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              controller: _scrollController,
              itemCount: state.hasMore ? state.reqres.length + 1 : state.reqres.length,
              itemBuilder: (context, index) {
                if (index < state.reqres.length) {
                  final reqres = state.reqres[index];
                  return ReqresCard(reqres: reqres);
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
          if (state is ReqresError) {
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
