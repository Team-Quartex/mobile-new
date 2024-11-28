import 'dart:io';
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

  Future<List<Map<String, dynamic>>> fetchPostsByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/posts/user/$userId"),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'accessToken=$authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Upload Images
  Future<List<String>> uploadImages(List<File> files) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));

      // Attach files to the request
      for (var file in files) {
        request.files
            .add(await http.MultipartFile.fromPath('file-1', file.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        print(jsonData);
        // Extract filenames from response
        if (jsonData['files'] != null && jsonData['files'] is List) {
          return List<String>.from(
              jsonData['files'].map((file) => file['filename']));
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to upload images: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error uploading images: $e");
    }
  }

  // Add Post
  Future<void> addPost({
    required String description,
    required String location,
    required List<String> images,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts/addPost'),
        headers: {
          "Content-Type": "application/json",
          'Cookie': 'accessToken=$authToken',
        },
        body: jsonEncode({
          "desc": description,
          "location": location,
          "images": images,
        }),
      );

      print(response);

      if (response.statusCode != 200) {
        throw Exception("Failed to add post: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error adding post: $e");
    }
  }
}
