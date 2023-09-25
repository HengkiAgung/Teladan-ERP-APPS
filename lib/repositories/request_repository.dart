import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../components/modal_bottom_sheet_component.dart';
import '../config.dart';
import '../models/Attendance/LeaveRequestCategory.dart';
import '../models/Employee/WorkingShift.dart';
import '../utils/auth.dart';

class RequestRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<dynamic>> getRequest({String page = "1", required String type, required String key, required dynamic model, required String token,}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/get?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"][key];
      return it.map((e) {
        var data = model.fromJson(e);
        return data;
      }).toList();

    }
    return [];
  }

  Future<dynamic> getRequestDetail({required String id, required String type, required dynamic model, required String token}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/get/detail'),
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
      return model.fromJson(jsonDecode(response.body)["data"]);
    }

    return model.fromJson({});
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
      ModalBottomSheetComponent().errorIndicator(context, 'Masukkan Check In atau Check Out!');

      return false;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

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
      String minute = selectedTimeIn.minute.toString();
      if (minute.length < 2) {
        minute = "0$minute";
      }
      request.fields['check_in'] = "$hour:$minute";
    } 
    if (selectedTimeOut != null) {
      String hour = selectedTimeOut.hour.toString();
      if (hour.length < 2) {
        hour = "0$hour";
      }
      String minute = selectedTimeOut.minute.toString();
      if (minute.length < 2) {
        minute = "0$minute";
      }
      request.fields['check_out'] = "$hour:$minute";
    }

    try {
      final response = await request.send();
 
      final responseString = await response.stream.bytesToString();
      final message = jsonDecode(responseString)["message"];

      Navigator.pop(context);

      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ModalBottomSheetComponent().errorIndicator(context, message);

        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Error sendiring request: $e");


      return false;
    }
  }

  Future<List<WorkingShift>> getAllWorkingShift() async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/get/working-shift'),
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

  Future<WorkingShift> getCurrentShift({required String token}) async {
        final response = await http.get(
      Uri.parse('$_baseUrl/cmt-request/personal/shift/get/current/shift'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return WorkingShift.fromJson(jsonDecode(response.body)["data"]);
    }
    return WorkingShift.fromJson({});
  }

  Future<bool> makeShiftRequest(
    BuildContext context,
    DateTime date,
    String working_shift_id,
    String? reason,
  ) async {
    String? token = await Auth().getToken();
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); 

    if (working_shift_id == "") {
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Shift baru wajib diisi!");
      return false;
    }

    if (date.isBefore(now)) {
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Tanggal mulai tidak boleh lebih kecil dari sekarang!");
      return false;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

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

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    if (int.parse(response.statusCode.toString()[0]) == 2) {
      return true;
      
    } else {
      final errorMessage = json.decode(response.body)['message'];

      ModalBottomSheetComponent().errorIndicator(context, errorMessage);

      return false;
    }
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
      ModalBottomSheetComponent().errorIndicator(context, "Kolom kategori wajib diisi!");
      return false;
    }

    if (startDate.isBefore(now)) {
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Tanggal mulai tidak boleh lebih kecil dari sekarang!");
      return false;
    }

    if (endDate.isBefore(startDate)) {
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Tanggal selesai tidak boleh lebih kecil dari tanggal mulai!");
      return false;
    }

    if (_selectedFile == null) {
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "File bukti wajib diisi!");
      return false;
    }

    ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/cmt-request/personal/time-off/make'),
    ); 
    
    var imageFile = await http.MultipartFile.fromPath(
      'file',
      _selectedFile.path!,
      filename: _selectedFile.name,
    );

    request.files.add(imageFile);

    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';    
    request.fields['start_date'] = "${startDate.year}-${startDate.month}-${startDate.day}";
    request.fields['end_date'] = "${endDate.year}-${endDate.month}-${endDate.day}";
    request.fields['notes'] = reason ?? "";
    request.fields['leave_request_category_id'] = categoryId;

    try {
      final response = await request.send();

      Navigator.pop(context);
      if (int.parse(response.statusCode.toString()[0]) == 2) {
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ModalBottomSheetComponent().errorIndicator(context, "Error uploading file");
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ModalBottomSheetComponent().errorIndicator(context, "Error sendiring request: $e");

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

  Future<bool> cancelRequest({required int id, required String type}) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/personal/$type/cancel'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}