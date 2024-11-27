import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'package:http/http.dart' as http;

class SearchClass extends ApiService {
  String? _authKey;

  SearchClass() {
    _authKey = GetIt.instance.get<ApiService>().authToken!;
  }

  Future<List<Map<String, dynamic>>> searchSuggetions() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/search/searchall"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$_authKey',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> dataList = data['data'];

        return dataList.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> filterSearch(String query) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/search/searchquey?search=$query"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$_authKey',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> dataList = data['data'];

        return dataList.map((item) => item as Map<String, dynamic>).toList();
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
