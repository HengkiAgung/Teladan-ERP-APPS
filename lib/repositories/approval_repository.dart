import 'dart:convert';

import 'package:http/http.dart' as http;
import '../config.dart';

class ApprovalRepository {
  static final String _baseUrl = Config.apiUrl;

  Future<List<dynamic>> getRequest({
    String page = "1",
    required String key,
    required String type,
    required dynamic model,
    required String token,
  }) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/cmt-request/$type/get'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'page': page,
            }));

    if (jsonDecode(response.body)["status"] == "success") {
      Iterable it = jsonDecode(response.body)["data"][key];
      return it.map((e) {
        return model.fromJson(e);
      }).toList();
    }

    return [];
  }

  Future<dynamic> getDetailRequest({
    required String id,
    required String type,
    required dynamic model,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cmt-request/$type/get/detail'),
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
      return model.fromJson(jsonDecode(response.body)["data"]);
    }

    return model.fromJson({});
  }

  Future<bool> updateRequest({
    required String type,
    required String id,
    required String status,
    String? comment,
    required String token,
  }) async {
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
