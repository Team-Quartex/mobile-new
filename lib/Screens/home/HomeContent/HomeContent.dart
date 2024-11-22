import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trova/api_service.dart';
import 'package:trova/class/post_class.dart';
import 'package:trova/class/user_class.dart';
import 'package:trova/widget/post_card.dart';
import 'package:trova/widget/post_description.dart';
import 'Comment.dart';
import 'Like.dart';
import 'Cart.dart';

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
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userClass = GetIt.instance.get<UserClass>();
            userId = userClass.userid;
            profilePic = userClass.profilepic;
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 80,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: userClass.profilepic != null
                              ? NetworkImage(
                                  'http://192.168.0.102/uploads/${userClass.profilepic}')
                              : AssetImage('assets/default_profile_pic.png'),
                          radius: 25,
                        ),
                        SizedBox(width: 10),
                        Text('Welcome',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(userClass.name.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 0, 0, 0))),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cart()));
                    },
                  ),
                ],
              ),
              body: FutureBuilder<List<Map<String, dynamic>>>(
                future: PostClass().fetchPost(),
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
                        final post = posts[index];
                        return PostCard(post: post, userId: userId!,profilePic: profilePic!,);
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
                        backgroundImage: NetworkImage(
                            "http://192.168.0.102/uploads/${post['profilePic']}"),
                        radius: 25,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(post['name'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                ),
                                child: Text(
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
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_vert),
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
                    : Container(
                        height: 250,
                        child: PageView.builder(
                          padEnds: false,
                          itemCount: post['images'].length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              "http://192.168.0.102:8000/uploads/${post['images'][index]}",
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
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
                        icon: Icon(Icons.favorite,
                            size: 20,
                            color: post['likeduser'].contains(userId.toString())
                                ? Color(0xFFFF0000)
                                : Color.fromARGB(255, 78, 78, 78)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Like()));
                        },
                      ),
                      SizedBox(width: 5),
                      Text('${post['likeduser']?.length ?? 0} Likes',
                          style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.comment, size: 20, color: Colors.grey),
                        onPressed: () {},
                      ),
                      SizedBox(width: 5),
                      Text('${post['comments']} Comments',
                          style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.share, size: 20, color: Colors.grey),
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
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
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 18),
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

  // Widget buildPostCard(Post post) {
  //   return Card(
  //     margin: EdgeInsets.all(10),
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       children: [
  //         Card(
  //           margin: EdgeInsets.all(8),
  //           color: Color(0xFFE0EEEE),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Row(
  //                   children: [
  //                     CircleAvatar(
  //                       backgroundImage: AssetImage(post.userProfileImage),
  //                       radius: 25,
  //                     ),
  //                     SizedBox(width: 10),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(post.userName,
  //                                 style:
  //                                     TextStyle(fontWeight: FontWeight.bold)),
  //                             SizedBox(width: 10),
  //                             TextButton(
  //                               onPressed: () {},
  //                               style: TextButton.styleFrom(
  //                                 backgroundColor: Colors.black,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(20),
  //                                 ),
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: 12, vertical: 4),
  //                               ),
  //                               child: Text(
  //                                 'Follow',
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Text(post.postDate,
  //                             style: TextStyle(color: Colors.grey)),
  //                       ],
  //                     ),
  //                     Spacer(),
  //                     IconButton(
  //                       icon: Icon(Icons.more_vert),
  //                       onPressed: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //                 child: Text(post.postContent),
  //               ),
  //               Container(
  //                 height: 250,
  //                 child: PageView.builder(
  //                   itemCount: 1,
  //                   itemBuilder: (context, index) {
  //                     return Image.asset(post.postImage, fit: BoxFit.cover);
  //                   },
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                     horizontal: 10.0, vertical: 5.0),
  //                 child: Row(
  //                   children: [
  //                     IconButton(
  //                       icon: Icon(Icons.favorite,
  //                           size: 20, color: Color(0xFFFF0000)),
  //                       onPressed: () {
  //                         Navigator.push(context,
  //                             MaterialPageRoute(builder: (context) => Like()));
  //                       },
  //                     ),
  //                     SizedBox(width: 5),
  //                     Text('${post.likes} Likes',
  //                         style: TextStyle(color: Colors.grey)),
  //                     Spacer(),
  //                     IconButton(
  //                       icon: Icon(Icons.comment, size: 20, color: Colors.grey),
  //                       onPressed: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                                 builder: (context) => Comment()));
  //                       },
  //                     ),
  //                     SizedBox(width: 5),
  //                     Text('${post.comments} Comments',
  //                         style: TextStyle(color: Colors.grey)),
  //                     Spacer(),
  //                     IconButton(
  //                       icon: Icon(Icons.share, size: 20, color: Colors.grey),
  //                       onPressed: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:
  //               const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: Row(
  //               children: [
  //                 CircleAvatar(
  //                   radius: 20,
  //                   backgroundImage: AssetImage('assets/profile.jpg'),
  //                 ),
  //                 SizedBox(width: 10),
  //                 Expanded(
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintText: 'Type a comment...',
  //                       hintStyle: TextStyle(color: Colors.grey),
  //                       border: InputBorder.none,
  //                       enabledBorder: InputBorder.none,
  //                       focusedBorder: InputBorder.none,
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: EdgeInsets.all(1),
  //                   decoration: BoxDecoration(
  //                     color: Colors.black,
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: IconButton(
  //                     icon: Icon(Icons.send, color: Colors.white, size: 18),
  //                     onPressed: () {},
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
