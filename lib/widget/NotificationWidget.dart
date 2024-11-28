import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final Map<String, String>? userDetails;
  final VoidCallback? onView;

  const NotificationWidget({
    Key? key,
    required this.notification,
    this.onView,
    this.userDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isViewed = notification['isView'] == 'true';
    final notifyType = notification['notifytype'];
    final notifiedTime = notification['notifiedtime'];

    String timeAgo = '';
    try {
      final dateTime = DateTime.parse(notifiedTime);
      timeAgo = timeago.format(dateTime);
    } catch (e) {
      timeAgo = notifiedTime;
    }

    final profilePic = userDetails?['profilepic'];

    return ListTile(
      leading: profilePic != null
          ? CircleAvatar(
        backgroundImage: NetworkImage(profilePic),
      )
          : const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(userDetails?['username'] ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notifyType),
          Text(timeAgo),
        ],
      ),
      trailing: !isViewed
          ? ElevatedButton(
        onPressed: onView,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Color(0xFF238688),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        child: const Text("Mark as Read"),
      )
          : null,
    );
  }
}
