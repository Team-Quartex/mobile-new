import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onView;

  const NotificationWidget({
    Key? key,
    required this.notification,
    this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isViewed = notification['isView'] == 'true';

    return ListTile(
      leading: Icon(
        isViewed ? Icons.notifications : Icons.notifications_active,
        color: isViewed ? Colors.grey : Colors.blue,
      ),
      title: Text(notification['description']),
      subtitle: Text(notification['notifiedtime']),
      trailing: !isViewed
          ? ElevatedButton(
              onPressed: onView,
              child: const Text("Mark as Read"),
            )
          : null,
    );
  }
}
