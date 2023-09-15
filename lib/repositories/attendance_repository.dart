import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

import '../components/error_notification_component.dart';
import '../models/Attendance.dart';
import '../config.dart';
import '../utils/auth.dart';

class AttendanceRepository {
  static final String _baseUrl = Config.apiUrl;
  
  Future<Attendance> getAttendanceDetail({required String date, required String token}) async {
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

  void loadingIndicator(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, bottom: 40, top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sedang mengirim data...",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        loadingIndicator(context);
        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

        try {
          final response = await request.send();

          Navigator.pop(context);
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
          Navigator.pop(context);
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
          Uri.parse('$_baseUrl/cmt-attendance/attend/check-out'),
        );
        var data = await getImage();
        var imageFile = await http.MultipartFile.fromPath(
          'file',
          data.path,
          filename: "absen.jpg",
        );
        loadingIndicator(context);
        request.files.add(imageFile);

        request.headers['Accept'] = 'application/json';
        request.headers['Content-Type'] = 'multipart/form-data';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['latitude'] = latitude;
        request.fields['longitude'] = longitude;

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

  Future<List<Attendance>> getHistoryAttendance({String page = "1", required String token}) async {
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

  Future getSummaries(String? startDate, String? endDate) async {
    String? token = await Auth().getToken();

    String params = "?";
    if (startDate != null) {
      params += "startDate=$startDate";
    }
    if (endDate != null) {
      params += "endDate=$endDate";
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/cmt-attendance/summaries/me$params'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var summaries =jsonDecode(response.body)["data"]["summaries"];

      return summaries;
    }

    return null;
  }
}
