part of 'user_bloc.dart';


abstract class UserEvent {}

final class GetUserEvent extends UserEvent {}

final class RefreshUserEvent extends UserEvent {}
