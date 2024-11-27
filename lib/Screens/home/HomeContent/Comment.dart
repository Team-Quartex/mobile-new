import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final int postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isLoading = true;
  List<dynamic> comments = [];
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchComments(widget.postId);
  }

  Future<void> fetchComments(int postId) async {
    try {
      // Fetch comments for the post
      final response = await http.get(
        Uri.parse("http://192.168.65.1/api/comments?postId=$postId"),
      );

      if (response.statusCode == 200) {
        final commentsData = json.decode(response.body);

        // Now fetch user details for each comment
        for (var post_comments in commentsData) {
          final userResponse = await http.get(
            Uri.parse("http://192.168.65.1/api/userDetails?userId=${post_comments['userId']}"),
          );

          if (userResponse.statusCode == 200) {
            final userData = json.decode(userResponse.body);
            post_comments['username'] = userData['username'];
            post_comments['profilepic'] = userData['profilepic'];
          } else {
            post_comments['username'] = 'Anonymous';
            post_comments['profilepic'] = 'default_profile_pic.jpg';
          }
        }

        setState(() {
          comments = commentsData;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to load comments";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Exception: $e";
        isLoading = false;
      });
    }
  }



  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                        "http://192.168.65.1/uploads/${comment['profilepic']}"), // Updated to use fetched profilePic
                  ),
                  const SizedBox(width: 10),
                  // Comment details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        Text(
                          comment['username'] ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Comment content
                        Text(
                          comment['content'] ?? 'No comment content',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
