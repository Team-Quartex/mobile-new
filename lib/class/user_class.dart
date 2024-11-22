import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserClass extends ApiService {
  ApiService? _apiService;
  String? authToken;
  String? userName;
  int? userid;
  String? useremail;
  String? name;
  String? verify;
  String? profilepic;
  int? followersCount;
  int? followingCount;

  UserClass() {
    _apiService = GetIt.instance.get<ApiService>();
    authToken = _apiService!.authToken;
  }

  Future<void> fetchUser() async {
    print('token is $authToken');
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users/userDetails"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        userName = data['username'];
        userid = int.parse(data['userid'].toString());
        useremail = data['email'];
        name = data['name'];
        verify = data['verify'];
        profilepic = data['profilepic'];
        followersCount = int.parse(data['followers_count'].toString());
        followingCount = int.parse(data['following_count'].toString());
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> addFollow(int id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/users/addfollower?following=$id"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
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
