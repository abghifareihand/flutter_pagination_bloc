import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_pagination_bloc/data/models/reqres_model.dart';
import 'package:http/http.dart' as http;

class ReqresRemoteDatasource {
  Future<Either<String, List<ReqresModel>>> fetchReqres(int page) async {
    final url = 'https://reqres.in/api/users?page=$page';
    log("URL yang digunakan: $url"); // Print URL sebelum membuat permintaan

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      final List<ReqresModel> reqres = data.map((data) => ReqresModel.fromJson(data)).toList();
      return Right(reqres);
    } else {
      return const Left('Failed Get Users');
    }
  }
}
