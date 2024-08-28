import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_pagination_bloc/data/models/user_response_model.dart';
import 'package:http/http.dart' as http;

class UserRemoteDatasource {
  Future<Either<String, List<UserResponseModel>>> fetchUser(int page, int limit) async {
    final url = 'https://66c30af6d057009ee9bed4b6.mockapi.io/api/users?page=$page&limit=$limit';
    log("URL yang digunakan: $url"); // Print URL sebelum membuat permintaan

    final response = await http.get(Uri.parse(url));

    // log('Response Get Users : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> responseList = json.decode(response.body);
      final List<UserResponseModel> userList = responseList.map((data) => UserResponseModel.fromJson(data)).toList();
      return Right(userList);
    } else {
      return const Left('Failed Get Users');
    }
  }
}
