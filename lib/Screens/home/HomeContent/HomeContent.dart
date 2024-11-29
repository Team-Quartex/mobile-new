import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trova/Screens/home/HomeContent/NotificationPage.dart';
import 'package:trova/api_service.dart';
import 'package:trova/class/image_location.dart';
import 'package:trova/class/post_class.dart';
import 'package:trova/class/user_class.dart';
import 'package:trova/widget/post_card.dart';
import 'package:trova/widget/post_description.dart';
import 'Like.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _LandingpageState();
}

class _LandingpageState extends State<HomeContent> {
  ApiService? _apiService;
  int? userId;
  String? profilePic;

  @override
  void initState() {
    super.initState();
    _apiService = GetIt.instance.get<ApiService>();
  }

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
                toolbarHeight: 75,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: userClass.profilepic != null
                              ? NetworkImage(ImageLocation().imageUrl(
                              userClass.profilepic.toString()))
                              : const AssetImage(
                              'assets/default_profile_pic.png'),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userClass.name.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],


                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()),
                      );
                    },
                  ),
                ],
              ),
              body: FutureBuilder<List<Map<String, dynamic>>>(
                future: PostClass().fetchPost(),
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
                          profilePic: profilePic!,
                        );
                      },
                    );
                  }
                },
              ),
            );
          }
        });
  }

  Widget _postCard(Map<dynamic, dynamic> post) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8),
            color: const Color(0xFFE0EEEE),
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
                        backgroundImage: NetworkImage(
                            ImageLocation().imageUrl(
                                post['profilePic'].toString())),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(post['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                ),
                                child: const Text(
                                  'Follow',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(post['postTime'],
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark_border_rounded,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PostDescription(description: post['description']),
                ),
                post['images'].length == 0
                    ? Container()
                    : SizedBox(
                  height: 250,
                  child: PageView.builder(
                    padEnds: false,
                    itemCount: post['images'].length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        ImageLocation().imageUrl(
                            post['images'][index].toString()),
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border_outlined,
                            size: 20,
                            color: post['likeduser'].contains(userId.toString())
                                ? const Color(0xFFFF0000)
                                : const Color.fromARGB(255, 78, 78, 78)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Like()));
                        },
                      ),
                      const SizedBox(width: 5),
                      Text('${post['likeduser']?.length ?? 0} Likes',
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.comment,
                            size: 20, color: Colors.grey),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 5),
                      Text('${post['comments']} Comments',
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share,
                            size: 20, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a comment...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon:
                      const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}