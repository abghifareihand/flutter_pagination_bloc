import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/bloc/movie/movie_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/bloc/reqres/reqres_bloc.dart';
import 'package:flutter_pagination_bloc/presentation/pages/home_page.dart';
import 'package:flutter_pagination_bloc/presentation/pages/movie_infinite_page.dart';
import 'package:flutter_pagination_bloc/presentation/pages/movie_page.dart';
import 'package:flutter_pagination_bloc/presentation/pages/reqres_page.dart';

import 'presentation/bloc/movie_infinite/movie_infinite_bloc.dart';
import 'presentation/bloc/user/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => ReqresBloc(),
        ),
        BlocProvider(
          create: (context) => MovieBloc(),
        ),
        BlocProvider(
          create: (context) => MovieInfiniteBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: false,
        ),
        home: const MovieInfinitePage(),
      ),
    );
  }
}
