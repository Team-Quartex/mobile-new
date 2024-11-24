import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductClass extends ApiService {
  ApiService? _apiService;
  @override
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

  Future<List<Map<String, dynamic>>> getReviews(int proid) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/reviews/reviews?productId=$proid"),
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

  Future<Map<String, dynamic>> getAvailableProducts(
      String start, String end, int proid) async {
    try {
      final response = await http.get(
        Uri.parse(
            "$baseUrl/reservation/check?end=$end&start=$start&itemId=$proid"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        return data[0];
      } else {
        print("Error: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Exception: $e");
      return {};
    }
  }

  Future<bool> addReservation(
      int proid, int qty, String start, String end) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reservation/addreservation"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
        body: json.encode({
          "productId": proid,
          "quantity": qty,
          "start": start,
          "end": end,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/reservation/userorders?userId=$userId"),
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
}
