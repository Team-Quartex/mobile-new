import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  String baseUrl = "http://172.20.10.4/api";

  ApiService();
  String? token;
  String? error;
  String? authToken;

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/api/items'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<bool> userRegister(
      String username, String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users/register"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
          "name": name
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        error = response.reasonPhrase;
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> userLogin(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users/login"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "username": username,
          "password": password,
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        print('Login successful');
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          // Extract and store the access token from the cookies
          // Assuming the cookie is in a "token=" format
          authToken = _extractTokenFromCookie(cookies);
          print('Access token: $authToken');
        }
        return true;
      } else {
        print(response.statusCode);
        error = response.reasonPhrase;
        print(error);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  String _extractTokenFromCookie(String cookie) {
    // Refined regex pattern to match 'accessToken=<your-token-value>'
    final tokenPattern = RegExp(r'accessToken=([^;]+)');
    final match = tokenPattern.firstMatch(cookie);
    return match?.group(1) ??
        ''; // Return the token or an empty string if not found
  }

  Future<Map<String, dynamic>?> fetchUserDetails(int userId) async {
    print("Fetching user details for userId: $userId");

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/otheruser?uid=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        return json.decode(response.body);
      } else {
        print("Error: Failed to load user details (status code: ${response.statusCode})");
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // Add Saved Post method
  Future<bool> addSavedPost(int postId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/savedpost/addsavedposts"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "postId": postId,
        }),
      );

      if (response.statusCode == 200) {
        print('Post saved successfully');
        return true;
      } else {
        print("Failed to save post: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Error while saving post: $e");
      return false;
    }
  }

  // Remove Saved Post method
  Future<bool> removeSavedPost(int postId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/savedpost/removesavedpost"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "postId": postId,
        }),
      );

      if (response.statusCode == 200) {
        print('Post removed successfully');
        return true;
      } else {
        print("Failed to remove post: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Error while removing post: $e");
      return false;
    }
  }


  Future<List<int>> fetchSavedPosts(int postId) async {
    final response = await get(Uri.parse('http://172.20.10.4/api/getsavedposts?postId=$postId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<int>.from(data);
    } else {
      throw Exception('Failed to load saved posts');
    }
  }

}




