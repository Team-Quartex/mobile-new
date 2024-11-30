// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class OrderService {
//   final String baseUrl = "http://172.20.10.4/api";
//
//   Future<List<dynamic>> fetchOrderHistory() async {
//     final response = await http.get(Uri.parse('$baseUrl/check'));
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load order history');
//     }
//   }
// }
