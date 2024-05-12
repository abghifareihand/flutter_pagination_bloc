part of 'user_bloc.dart';

abstract class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final List<UserResponseModel> userResponse;
  final bool hasMore;
  UserLoaded(this.userResponse, this.hasMore );
}

final class UserError extends UserState {
  final String message;

  UserError(this.message);
}
