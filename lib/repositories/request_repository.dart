import 'dart:convert';

import 'package:comtelindo_erp/models/Attendance/UserAttendanceRequest.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/Attendance/UserShiftRequest.dart';
import '../utils/auth.dart';

class RequestRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<UserAttendanceRequest>> getAllUserAttendanceRequest() async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/attendance/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['userAttendanceRequest'];
      List<UserAttendanceRequest> userAttendance = it.map((e) {
        var attendance = UserAttendanceRequest.fromJson(e);
        return attendance;
      }).toList();

      return userAttendance;
    }

    return [];
  }

  Future<List<UserShiftRequest>> getAllUserShiftRequest() async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/shift/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];
      List<UserShiftRequest> userShift = it.map((e) {
        var attendance = UserShiftRequest.fromJson(e);
        return attendance;
      }).toList();

      return userShift;
    }

    return [];
  }
}