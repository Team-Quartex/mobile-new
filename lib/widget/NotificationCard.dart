import 'package:flutter/material.dart';
import 'notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Icon(
          notification.notifyType == "like"
              ? Icons.thumb_up
              : Icons.person_add, // Icons based on type
          color: Colors.blue,
        ),
        title: Text(notification.description ?? "No description available"),
        subtitle: Text("Time: ${notification.notifiedTime}"),
        trailing: notification.isView
            ? const Icon(Icons.check, color: Colors.green)
            : const Icon(Icons.new_releases, color: Colors.red),
      ),
    );
  }
}
