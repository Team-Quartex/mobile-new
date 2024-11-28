import 'package:flutter/material.dart';
import 'package:trova/class/UserPostClass.dart';
import 'package:trova/widget/post_card.dart';
import 'package:get_it/get_it.dart';

import '../../api_service.dart';
import '../../class/user_class.dart';

class Otherusers extends StatefulWidget {
  final int userId;

  const Otherusers({super.key, required this.userId});

  @override
  State<Otherusers> createState() => _OtherusersState();
}

class _OtherusersState extends State<Otherusers> {
  int? userId;
  String? profilePic;
  Map<String, dynamic>? userDetails;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _fetchUserDetails();
  }

  // Fetch user details using the provided userId
  Future<void> _fetchUserDetails() async {
    try {
      final apiService = GetIt.instance.get<ApiService>();
      final data = await apiService.fetchUserDetails(userId!);
      setState(() {
        userDetails = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'Failed to load user data: $error',
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: userDetails?['profilepic'] != null
                      ? NetworkImage(
                      'http://172.20.10.4/uploads/${userDetails?['profilepic']}')
                      : const AssetImage('assets/default_profile_pic.png') as ImageProvider,
                  radius: 50,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userDetails?['username'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${userDetails?['name'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 18, color: Color(0xFF238688)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${userDetails?['followers_count']?.toString() ?? '0'} Following',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${userDetails?['following_count']?.toString() ?? '0'} Followers',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (userDetails?['verify'] == 'yes')
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (userDetails?['isFollowed'] == 'yes') {
                      // Unfollow functionality
                    } else {
                      await UserClass().addFollow(userDetails?['userId']);
                      setState(() {
                        userDetails?['isFollowed'] = 'yes';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF238688), // button color
                    minimumSize: const Size(270, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                  child: Text(
                    userDetails?['isFollowed'] == 'yes' ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),



            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: UserPostClass().fetchUserPosts(userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No posts available'));
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          userId: userId!,
                          profilePic: userDetails?['profilepic'] ?? 'default_profile_pic.png',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
