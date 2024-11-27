import 'package:flutter/material.dart';
import 'package:trova/class/Notification_Class.dart';
import 'package:trova/widget/NotificationWidget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationClass _notificationClass;
  late Future<List<Map<String, dynamic>>> _notifications;

  @override
  void initState() {
    super.initState();
    _notificationClass = NotificationClass();
    _notifications = _notificationClass.getNotifications();
  }

  void _markAsRead(int notifyId) async {
    final success = await _notificationClass.markAsRead(notifyId);
    if (success) {
      setState(() {
        _notifications = _notificationClass.getNotifications();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to mark notification as read')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading notifications"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications available"));
          } else {
            final notifications = snapshot.data!;
            print("Notifications loaded: $notifications");

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationWidget(
                  notification: notification,
                  onView: () => _markAsRead(notification['notifyid']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
