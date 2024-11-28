import 'package:flutter/material.dart';
import 'package:trova/Screens/Profile/EditProfile.dart';
import 'package:trova/Screens/Profile/OrderHistory.dart';
import 'package:trova/class/UserPostClass.dart';
import 'package:trova/class/image_location.dart';
import 'package:trova/class/user_class.dart';
import 'package:trova/widget/post_card.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? userId;
  String? profilePic;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.instance.get<UserClass>().fetchUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userClass = GetIt.instance.get<UserClass>();
          userId = userClass.userid;
          profilePic = userClass.profilepic;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.store_rounded, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderHistory()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: userClass.profilepic != null
                            ? NetworkImage(
                                ImageLocation().imageUrl(userClass.profilepic.toString()))
                            : const AssetImage(
                                'assets/default_profile_pic.png'),
                        radius: 50,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userClass.userName.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 4),
                          Text('@${userClass.name.toString()}',
                              style: const TextStyle(
                                  fontSize: 18, color: Color(0xFF238688))),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                  '${userClass.followersCount.toString()} Following',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(width: 16),
                              Text(
                                  '${userClass.followingCount.toString()} Followers',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: UserPostClass().fetchUserPosts(userId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No posts available'));
                        } else {
                          final posts = snapshot.data!;
                          return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return PostCard(
                                post: post,
                                userId: userId!,
                                profilePic: profilePic!,
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
      },
    );
  }
}
