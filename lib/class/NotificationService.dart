import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'package:trova/model/NotificationModel.dart';

class NotificationService extends ApiService {
  ApiService? _apiService;
  @override
  String? authToken;

  NotificationService() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/viewnotification/getall'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<NotificationModel> notifications = [];
        for (var item in data) {
          notifications.add(NotificationModel.fromJson(item));
        }
        return notifications;
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }
}
