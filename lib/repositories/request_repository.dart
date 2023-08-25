import 'dart:convert';

import 'package:comtelindo_erp/models/Request/UserAttendanceRequest.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../utils/auth.dart';

class RequestRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<UserAttendanceRequest>> getAlluserAttendance() async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];
      List<UserAttendanceRequest> userAttendance = it.map((e) {
        var attendance = UserAttendanceRequest.fromJson(e);
        return attendance;
      }).toList();

      return userAttendance;
    }

    return [];
  }
}