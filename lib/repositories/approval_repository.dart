import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/Attendance/UserAttendanceRequest.dart';
import '../models/Attendance/UserLeaveRequest.dart';
import '../models/Attendance/UserShiftRequest.dart';
import '../utils/auth.dart';

class ApprovalRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<UserAttendanceRequest>> getAttendanceApproval({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/attendance/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'page': page,
      })
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

  Future<UserAttendanceRequest> getDetailAttendanceApproval(String id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/attendance/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'id': id,
        }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      var attendance = UserAttendanceRequest.fromJson(jsonDecode(response.body)["data"]);

      return attendance;
    }

    return UserAttendanceRequest.fromJson({});
  }

  Future<List<UserShiftRequest>> getShiftApproval({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/shift/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'page': page,
      })
    );

    if (jsonDecode(response.body)["status"] == "success") {
      Iterable it = jsonDecode(response.body)["data"]['userShiftRequest'];
      List<UserShiftRequest> userShift = it.map((e) {
        var attendance = UserShiftRequest.fromJson(e);
        return attendance;
      }).toList();

      return userShift;
    }

    return [];
  }

  Future<UserShiftRequest> getDetailShiftApproval(String id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/shift/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'id': id,
        }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      var attendance = UserShiftRequest.fromJson(jsonDecode(response.body)["data"]);

      return attendance;
    }

    return UserShiftRequest.fromJson({});
  }

  Future<List<UserLeaveRequest>> getTimeOffApproval({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/timeoff/get'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'page': page,
      })
    );

    if (jsonDecode(response.body)["status"] == "success") {
      Iterable it = jsonDecode(response.body)["data"]['userTimeOffRequest'];
      List<UserLeaveRequest> userLeave = it.map((e) {
        var attendance = UserLeaveRequest.fromJson(e);
        return attendance;
      }).toList();

      return userLeave;
    }

    return [];
  }

  Future<UserLeaveRequest> getDetailTimeOffApproval(String id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/timeoff/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'id': id,
        }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      var attendance = UserLeaveRequest.fromJson(jsonDecode(response.body)["data"]);

      return attendance;
    }

    return UserLeaveRequest.fromJson({});
  }
  
    Future<bool> updateApproval({required String type, required String id, required String status, String? comment}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/$type/update/status'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'id': id,
          'status': status,
          'comment': comment,
        }),
    );

    if (jsonDecode(response.body)["status"] == "success") {
      return true;
    }

    return false;
  }
}