import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.0.100/api";

  static final ApiService _instance = ApiService._internal();
  String? error;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

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
        print('hi12');
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
}
