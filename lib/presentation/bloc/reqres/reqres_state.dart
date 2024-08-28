part of 'reqres_bloc.dart';

abstract class ReqresState {}

final class ReqresInitial extends ReqresState {}

final class ReqresLoading extends ReqresState {}

final class ReqresLoaded extends ReqresState {
  final List<ReqresModel> reqres;
  final bool hasMore;
  ReqresLoaded(this.reqres, this.hasMore);
}

final class ReqresError extends ReqresState {
  final String message;

  ReqresError(this.message);
}
