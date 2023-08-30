import 'dart:convert';

import 'package:comtelindo_erp/models/Employee/UserEmployment.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/Employee/User.dart';
import '../models/Employee/UserBPJS.dart';
import '../models/Employee/UserBank.dart';
import '../models/Employee/UserSalary.dart';
import '../models/Employee/UserTax.dart';
import '../utils/auth.dart';

class UserRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<User> getUser() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/me"),
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

    await Auth().deleteToken();

    return User.fromJson({});
  }

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

  Future<UserSalary> getUserSalary() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/payroll/salary/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserSalary data = UserSalary.fromJson(jsonDecode(response.body)["data"]);

      return data;
    }

    return UserSalary.fromJson({});
  }

  Future<UserBank> getUserBank() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/payroll/bank/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserBank data = UserBank.fromJson(jsonDecode(response.body)["data"]);

      return data;
    }

    return UserBank.fromJson({});
  }

  Future<UserTax> getUserTax() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/payroll/tax/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserTax data = UserTax.fromJson(jsonDecode(response.body)["data"]);

      return data;
    }

    return UserTax.fromJson({});
  }

  Future<UserBpjs> getUserBpjs() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse("${Config.apiUrl}/user/payroll/bpjs/data"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      UserBpjs data = UserBpjs.fromJson(jsonDecode(response.body)["data"]);

      return data;
    }

    return UserBpjs.fromJson({});
  }
}
