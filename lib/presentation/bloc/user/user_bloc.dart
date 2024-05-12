import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/data/datasources/user_remote_datasource.dart';
import 'package:flutter_pagination_bloc/data/models/user_response_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final int limit = 15;
  int page = 1;
  bool hasMore = true;
  List<UserResponseModel> users = [];

  UserBloc() : super(UserInitial()) {
    on<GetUserEvent>((event, emit) async {
      final result = await UserRemoteDatasource().fetchUser(page, limit);
      result.fold(
        (error) => emit(UserError(error)),
        (data) {
          debugPrint('Get User: ${data.length}');
          debugPrint('Page: $page');
          hasMore = data.length < limit ? false : true;
          users.addAll(data);
          page++;
          debugPrint('Total Users: ${users.length}');
          emit(UserLoaded(users, hasMore));
        },
      );
    });
  }
}
