import 'dart:convert';

import 'package:comtelindo_erp/models/Employee/UserEmployment.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/Employee/User.dart';
import '../utils/auth.dart';

class UserRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<User> getUserPersonalData() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/personal/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      User user = User.fromJson(jsonDecode(response.body)["data"]);

      return user;
    }

    return User.fromJson({});
  }

  Future updateUserPersonalData(
    String name,
    String email,
    String kontak,
    String place_of_birth,
    String birthdate,
    String marital_status,
    String gender,
    String religion,
    String blood_type,
  ) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/user/update/personal/data'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'name' : name,
          'email' : email,
          'kontak' : kontak,
          'place_of_birth' : place_of_birth,
          'birthdate' : birthdate,
          'marital_status' : marital_status,
          'gender' : gender,
          'religion' : religion,
          'blood_type' : blood_type,
        }),
    );

    return jsonDecode(response.body);
  }

  Future<UserEmployment> getUserEmploymentData() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/employment/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserEmployment user = UserEmployment.fromJson(jsonDecode(response.body)["data"]);

      return user;
    }

    return UserEmployment.fromJson({});
  }

}
