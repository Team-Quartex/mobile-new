import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trova/class/image_location.dart';

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isView = true;
    String notify = "";
    final notifyType = notification['notifytype'];
    final notifiedTime = notification['notifiedtime'];

    String timeAgo = '';
    try {
      final dateTime = DateTime.parse(notifiedTime);
      timeAgo = timeago.format(dateTime);
    } catch (e) {
      timeAgo = notifiedTime;
    }

    if (notification['isView'] == "no") {
      isView = false;
    }

    final profilePic = notification['profilepic'];

    switch (notification['notifytype']) {
      case "like":
        notify = "User like your Post";
        break;
      case "comment":
        notify = "User comment your Post";
        break;
      case "follow":
        notify = "User Start follow you";
        break;
      case "share":
        notify = "User share your post";
        break;
      default:
        notify = "";
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(ImageLocation().imageUrl(profilePic)),
      ),
      title: Text(notification['name']),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notify),
          Text(timeAgo,style: TextStyle(fontSize: 10),),
        ],
      ),
      trailing: isView
          ? const SizedBox.shrink()
          : const CircleAvatar(
              foregroundColor: Colors.green,
              radius: 10,
            ),
    );
  }
}
