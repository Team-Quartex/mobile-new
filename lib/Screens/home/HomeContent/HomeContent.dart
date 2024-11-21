import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:trova/model/post_model.dart';
import 'Comment.dart';
import 'Like.dart';
import 'Cart.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _LandingpageState();
}

class _LandingpageState extends State<HomeContent> {
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/api/posts/getall'));

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = json.decode(response.body);
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'),
                  radius: 25,
                ),
                SizedBox(width: 10),
                Text('Welcome', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Text('John Doe', style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return buildPostCard(posts[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            color: Color(0xFFE0EEEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(post.userProfileImage),
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(post.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                ),
                                child: Text(
                                  'Follow',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Text(post.postDate, style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(post.postContent),
                ),
                Container(
                  height: 250,
                  child: PageView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Image.asset(post.postImage, fit: BoxFit.cover);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite, size: 20, color: Color(0xFFFF0000)),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Like()));
                        },
                      ),
                      SizedBox(width: 5),
                      Text('${post.likes} Likes', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.comment, size: 20, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Comment()));
                        },
                      ),
                      SizedBox(width: 5),
                      Text('${post.comments} Comments', style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.share, size: 20, color: Colors.grey),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
