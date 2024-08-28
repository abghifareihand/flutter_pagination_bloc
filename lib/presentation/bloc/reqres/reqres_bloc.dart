import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/reqres_remote_datasource.dart';
import '../../../data/models/reqres_model.dart';

part 'reqres_event.dart';
part 'reqres_state.dart';

class ReqresBloc extends Bloc<ReqresEvent, ReqresState> {
  int page = 1;
  bool hasMore = true;
  List<ReqresModel> reqres = [];
  ReqresBloc() : super(ReqresInitial()) {
    on<GetReqresEvent>((event, emit) async {
      final result = await ReqresRemoteDatasource().fetchReqres(page);
      result.fold(
        (error) => emit(ReqresError(error)),
        (data) {
          print('Get User: ${data.length}');
          print('Page: $page');
          hasMore = data.isNotEmpty;
          reqres.addAll(data);
          page++;
          print('Total Users: ${reqres.length}');
          emit(ReqresLoaded(reqres, hasMore));
        },
      );
    });
  }
}
