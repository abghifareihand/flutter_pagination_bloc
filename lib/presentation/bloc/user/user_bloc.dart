import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_bloc/data/datasources/user_remote_datasource.dart';
import 'package:flutter_pagination_bloc/data/models/user_response_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final PagingController<int, UserResponseModel> pagingController = PagingController(firstPageKey: 1);

  UserBloc() : super(UserInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      add(GetUserEvent(page: pageKey));
    });
    on<GetUserEvent>((event, emit) async {
      final result = await UserRemoteDatasource().fetchUser(event.page, 10);
      result.fold(
        (error) => emit(UserError(error)),
        (data) {
          final hasMore = data.isNotEmpty;
          if (data.isEmpty) {
            pagingController.appendLastPage([]);
            emit(UserLoaded([], false));
          } else {
            if (hasMore) {
              pagingController.appendPage(data, event.page + 1);
            } else {
              pagingController.appendLastPage(data);
            }
            emit(UserLoaded(data, hasMore));
          }
        },
      );
    });
  }
}
