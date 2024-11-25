import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:trova/Screens/home/HomeContent/Comment.dart';
import 'package:trova/api_service.dart';
import 'package:trova/class/post_class.dart';
import 'package:trova/class/user_class.dart';
import 'package:trova/widget/post_description.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PostCard extends StatefulWidget {
  final Map<dynamic, dynamic> post;
  final int userId;
  final String profilePic;

  const PostCard(
      {super.key,
      required this.post,
      required this.userId,
      required this.profilePic});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likeCount = 0;
  bool isFollow = false;
  int commentCount = 0;
  ApiService? _apiService;
  final PostClass _postClass = PostClass();
  final UserClass _userClass = UserClass();
  final TextEditingController _commentcontroller = TextEditingController();
  final bool isSaved = false;

  @override
  void initState() {
    super.initState();
    // Initialize the like state and count from the post data
    isLiked = widget.post['likeduser'].contains(widget.userId.toString());
    likeCount = widget.post['likeduser'].length;
    commentCount = widget.post['comments'];
    isFollow =
        (widget.post['isFollowed'] == 'no' && widget.post['verify'] == 'yes') &&
            widget.post['userId'] != widget.userId;
    _apiService = GetIt.instance.get<ApiService>();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likeCount++;
        _postClass.likePosts(widget.post['postId']);
      } else {
        likeCount--;
        _postClass.removeLike(widget.post['postId']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            "http://192.168.0.102/uploads/${widget.post['profilePic']}"),
                        radius: 25,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(widget.post['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              isFollow
                                  ? TextButton(
                                      onPressed: () {
                                        _userClass
                                            .addFollow(widget.post['userId']);
                                        setState(() {
                                          isFollow = !isFollow;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          Text(widget.post['postTime'],
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const Spacer(),
                      isFollow
                          ? IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                size: 20,
                              ),
                              onPressed: () {},
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.bookmark_border_rounded,
                                size: 20,
                              ),
                              onPressed: () {},
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child:
                      PostDescription(description: widget.post['description']),
                ),
                widget.post['images'].length == 0
                    ? Container()
                    : SizedBox(
                        height: 250,
                        child: PageView.builder(
                          padEnds: false,
                          itemCount: widget.post['images'].length,
                          itemBuilder: (context, index) {
                            return ZoomOverlay(
                                modalBarrierColor: Colors.black12,
                                child: Image.network(
                                  "http://192.168.0.102:8000/uploads/${widget.post['images'][index]}",
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ));
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
                            color: isLiked
                                ? const Color(0xFFFF0000)
                                : const Color.fromARGB(255, 78, 78, 78)),
                        onPressed: _toggleLike,
                      ),
                      const SizedBox(width: 5),
                      Text('$likeCount Likes',
                          style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.comment,
                            size: 20, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Comment()));
                        },
                      ),
                      const SizedBox(width: 5),
                      Text('$commentCount Comments',
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        "http://192.168.0.102/uploads/${widget.profilePic}"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _commentcontroller,
                      decoration: const InputDecoration(
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
                      onPressed: () {
                        if (_commentcontroller.text.isNotEmpty) {
                          PostClass().addComment(
                              widget.post['postId'], _commentcontroller.text);
                          setState(() {
                            commentCount++;
                          });
                        }
                      },
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
