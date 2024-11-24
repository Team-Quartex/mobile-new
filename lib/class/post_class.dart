import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostClass extends ApiService {
  ApiService? _apiService;
  @override
  String? authToken;
  PostClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<Map<String, dynamic>>> fetchPost() async {
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

  Future<void> likePosts(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/likes/add"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "postId": id,
        }),
      );
      if (response.statusCode == 200) {
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> removeLike(int id) async {
    print("HI");
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/likes/remove"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "postId": id,
        }),
      );
      if (response.statusCode == 200) {
        print("object");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> addComment(int id, String content) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/comments/addcomment"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "postId": id,
          "content": content,
        }),
      );
      if (response.statusCode == 200) {
        print("object");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
