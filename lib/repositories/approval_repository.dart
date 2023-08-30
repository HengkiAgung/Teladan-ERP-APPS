import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/Attendance/UserAttendanceRequest.dart';
import '../utils/auth.dart';

class ApprovalRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<UserAttendanceRequest>> getApprovalAttendance() async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/attendance/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (jsonDecode(response.body)["status"] == "success") {
      Iterable it = jsonDecode(response.body)["data"]['userAttendanceRequest'];
      List<UserAttendanceRequest> userAttendance = it.map((e) {
        var attendance = UserAttendanceRequest.fromJson(e);
        return attendance;
      }).toList();

      return userAttendance;
    }

    return [];
  }
}