import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/Request/UserAttendanceRequest.dart';
import '../utils/auth.dart';

class ApprovalRepository {
  static final String _baseUrl = Config.apiUrl;

    Future<List<UserAttendanceRequest>> getApprovalAttendance() async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-approval/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["data"][0]["user"]);
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