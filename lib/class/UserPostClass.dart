import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trova/api_service.dart';
import 'package:get_it/get_it.dart';

class UserPostClass extends ApiService {
  ApiService? _apiService;
  @override
  String? authToken;

  UserPostClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<Map<String, dynamic>>> fetchUserPosts(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/posts/getall"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data
            .map((item) => item as Map<String, dynamic>)
            .where((post) => post['userId'] == userId)
            .toList();
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
