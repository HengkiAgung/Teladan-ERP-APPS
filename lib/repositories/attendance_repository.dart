import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import '../components/error_notification_component.dart';
import '../models/Attendance.dart';
import '../config.dart';
import '../utils/auth.dart';

class AttendanceRepository {
  static final String _baseUrl = Config.apiUrl;
  
  Future<Attendance> getAttendanceDetail(String date) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-attendance/history/detail'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
          'date': date,
        }),
    );

    if (response.statusCode == 200) {
      Attendance attendance =
          Attendance.fromJson(jsonDecode(response.body)["data"] ?? {});

      return attendance;
    }

    return Attendance.fromJson(jsonDecode(response.body));
  }
  
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);

    return imageTemporary;
  }

  Future getLocation() async {
    Location location = Location();

    bool serviceEneabled = await location.serviceEnabled();
    if (!serviceEneabled) {
      serviceEneabled = await location.requestService();
      if (!serviceEneabled) {
        return Future.error("Location disabled");
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error("Location permissions are denied");
      }
    }

    return await location.getLocation();
  }

  Future<bool> validateLocation(BuildContext context, String latitude, String longitude) async {
    String? token = await Auth().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-attendance/attend/location/validate'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    final bodyResponse = json.decode(response.body);

    if (bodyResponse["status"] == "success") {
      return true;
    }

    final errorMessage = json.decode(response.body)['message'];
    ErrorNotificationComponent().showModal(context, errorMessage);

    return false;
  }

  Future<bool> checkIn(BuildContext context) async {
    try {
      String? token = await Auth().getToken();
      String latitude = "0";
      String longitude = "0";

      await getLocation().then((value) {
        latitude = '${value.latitude}';
        longitude = '${value.longitude}';
      });

      bool validate = await validateLocation(context, latitude, longitude);

      if (validate) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/cmt-attendance/attend/check-in'),
        );
        var data = await getImage();
        var imageFile = await http.MultipartFile.fromPath(
          'file',
          data.path,
          filename: "absen.jpg",
        );
        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

        try {
          final response = await request.send();

          if (response.statusCode == 200) {
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

      return false;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        e.toString(),
      );

      return false;
    }
  }

  Future<bool> checkOut(BuildContext context) async {
    try {
      String? token = await Auth().getToken();
      String latitude = "-1.2495105";
      String longitude = "116.8749959";

      // await getLocation().then((value) {
      //   latitude = '${value.latitude}';
      //   longitude = '${value.longitude}';
      // });

      bool validate = await validateLocation(context, latitude, longitude);

      if (validate) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/cmt-attendance/attend/check-out'),
        );
        var data = await getImage();
        var imageFile = await http.MultipartFile.fromPath(
          'file',
          data.path,
          filename: "absen.jpg",
        );
        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

        try {
          final response = await request.send();

          if (response.statusCode == 200) {
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

      return false;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ErrorNotificationComponent().showModal(
        context,
        e.toString(),
      );

      return false;
    }
  }

  Future<List<Attendance>> getHistoryAttendance({String page = "1"}) async {
    String? token = await Auth().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-attendance/history?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable it = jsonDecode(response.body)["data"]['attendance'];

      List<Attendance> attendance = it.map((e) {
        return Attendance.fromJson(e);
      }).toList();

      return attendance;
    }

    return [];
  }
}
