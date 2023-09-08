import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/error_notification_component.dart';
import '../config.dart';
import '../models/Attendance/LeaveRequestCategory.dart';
import '../models/Attendance/UserAttendanceRequest.dart';
import '../models/Attendance/UserLeaveRequest.dart';
import '../models/Attendance/UserShiftRequest.dart';
import '../models/Employee/WorkingShift.dart';
import '../utils/auth.dart';

class RequestRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<UserAttendanceRequest>> getAllUserAttendanceRequest({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/attendance/get?page=$page'),
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

  Future<UserAttendanceRequest> getDetailUserAttendanceRequest(int id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/attendance/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      UserAttendanceRequest userAttendanceRequest = UserAttendanceRequest.fromJson(jsonDecode(response.body)["data"]);

      return userAttendanceRequest;
    }

    return UserAttendanceRequest.fromJson(jsonDecode(response.body));
  }

  Future<bool> makeAttendanceRequest(
    BuildContext context,
    DateTime selectedDate,
    TimeOfDay? selectedTimeIn,
    TimeOfDay? selectedTimeOut,
    TextEditingController? descriptionController,
    PlatformFile? _selectedFile,
  ) async {
    String? token = await Auth().getToken();

    if (selectedTimeIn == null && selectedTimeOut == null) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Masukkan Check In atau Check Out!',
      );

      return false;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/cmt-request/personal/attendance/make'),
    ); 
    
    if (_selectedFile != null) {
      var imageFile = await http.MultipartFile.fromPath(
        'file',
        _selectedFile.path!,
        filename: _selectedFile.name,
      );

      request.files.add(imageFile);
    }

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['date'] = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    request.fields['notes'] = descriptionController!.text;

    if (selectedTimeIn != null) {
      String hour = selectedTimeIn.hour.toString();
      if (hour.length < 2) {
        hour = "0$hour";
      }
      request.fields['check_in'] = "$hour:${selectedTimeIn.minute}";
    } 
    if (selectedTimeOut != null) {
      String hour = selectedTimeOut.hour.toString();
      if (hour.length < 2) {
        hour = "0$hour";
      }
      request.fields['check_out'] = "$hour:${selectedTimeOut.minute}";
    }

    try {
      final response = await request.send();
 
      final responseString = await response.stream.bytesToString();
      final message = jsonDecode(responseString)["message"];

      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ErrorNotificationComponent().showModal(
          context,
          message,
        );

        return false;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Error sending request: $e',
      );

      return false;
    }
  }

  Future<List<dynamic>> getAllUserShiftRequest({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/get?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['userShiftRequest'];
      List<UserShiftRequest> userShift = it.map((e) {
        var attendance = UserShiftRequest.fromJson(e);
        return attendance;
      }).toList();

      WorkingShift currentShift = WorkingShift.fromJson(jsonDecode(response.body)["data"]["currentShift"]);

      return [userShift, currentShift];
    }

    return [];
  }
  
  Future<UserShiftRequest> getDetailUserShiftRequest(int id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      UserShiftRequest userShiftRequest = UserShiftRequest.fromJson(jsonDecode(response.body)["data"]);

      return userShiftRequest;
    }

    return UserShiftRequest.fromJson(jsonDecode(response.body));
  }
  
  Future<List<WorkingShift>> getAllWorkingShift() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/shift/get/working-shift'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];
      List<WorkingShift> shift = it.map((e) {
        var attendance = WorkingShift.fromJson(e);
        return attendance;
      }).toList();

      return shift;
    }

    return [];
  }

  Future<bool> makeShiftRequest(
    BuildContext context,
    DateTime date,
    String working_shift_id,
    String? reason,
  ) async {
    String? token = await Auth().getToken();
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); 

    if (working_shift_id == null || working_shift_id == "") {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Shift baru wajib diisi!',
      );
      return false;
    }

    if (date.isBefore(now)) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Tanggal mulai tidak boleh lebih kecil dari sekarang!',
      );
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/make'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'date': "${date.year}-${date.month}-${date.day}",
        'working_shift_id': working_shift_id,
        'notes': reason,
      }),
    );

    if (int.parse(response.statusCode.toString()[0]) == 2) {

      // ignore: use_build_context_synchronously
      return true;
      
    } else {
      final errorMessage = json.decode(response.body)['message'];

      ErrorNotificationComponent().showModal(context, errorMessage);

      return false;
    }
  }

  Future<List<UserLeaveRequest>> getAllUserTimeOffRequest({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/time-off/get?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['userLeaveRequest'];
      List<UserLeaveRequest> userShift = it.map((e) {
        var attendance = UserLeaveRequest.fromJson(e);
        return attendance;
      }).toList();

      return userShift;
    }

    return [];
  }

  Future<bool> makeLeaveRequest(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
    String? categoryId,
    String? reason,
    PlatformFile? _selectedFile,
  ) async {
    String? token = await Auth().getToken();
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); 

    if (categoryId == null || categoryId == "") {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Kolom kategori wajib diisi!',
      );
      return false;
    }

    if (startDate.isBefore(now)) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Tanggal mulai tidak boleh lebih kecil dari sekarang!',
      );
      return false;
    }

    if (endDate.isBefore(startDate)) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Tanggal selesai tidak boleh lebih kecil dari tanggal mulai!',
      );
      return false;
    }

    if (_selectedFile == null) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'File bukti wajib diisi!',
      );
      return false;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/cmt-request/personal/time-off/make'),
    ); 
    
    if (_selectedFile != null) {
      var imageFile = await http.MultipartFile.fromPath(
        'file',
        _selectedFile.path!,
        filename: _selectedFile.name,
      );

      request.files.add(imageFile);
    }

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';    
    request.fields['start_date'] = "${startDate.year}-${startDate.month}-${startDate.day}";
    request.fields['end_date'] = "${endDate.year}-${endDate.month}-${endDate.day}";
    request.fields['notes'] = reason ?? "";
    request.fields['leave_request_category_id'] = categoryId;

    try {
      final response = await request.send();

      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ErrorNotificationComponent().showModal(
          context,
          'Error uploading file.',
        );

        return false;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        'Error sending request: $e',
      );

      return false;
    }
  }

  Future<List<LeaveRequestCategory>> getAllLeaveRequestCategory() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/get/category'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"];

      List<LeaveRequestCategory> categories = it.map((e) {
        var category = LeaveRequestCategory.fromJson(e);
        return category;
      }).toList();

      return categories;
    }

    return [];
  }

  Future<UserLeaveRequest> getDetailUserLeaveRequest(int id) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/time-off/get/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      UserLeaveRequest userAttendanceRequest = UserLeaveRequest.fromJson(jsonDecode(response.body)["data"]);

      return userAttendanceRequest;
    }

    return UserLeaveRequest.fromJson(jsonDecode(response.body));
  }
}