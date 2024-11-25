import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trova/api_service.dart';

class NotificationsClass extends ApiService {
  ApiService? _apiService;
  @override
  String? authToken;

  NotificationsClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/notification"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
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

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/notifications/viewnotification"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({"notificationId": notificationId}),
      );

      if (response.statusCode != 200) {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
