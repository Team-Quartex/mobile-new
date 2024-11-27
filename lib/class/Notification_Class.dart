import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationClass extends ApiService {
  ApiService? _apiService;
  @override
  String? authToken;

  NotificationClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/notification"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print("Parsed Data: $data");
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<bool> markAsRead(int notifyId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/notifications/viewnotification"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({'notifyId': notifyId}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
