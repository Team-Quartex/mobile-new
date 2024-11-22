import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductClass extends ApiService {
  ApiService? _apiService;
  String? authToken;
  ProductClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/products/viewall"),
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
}
