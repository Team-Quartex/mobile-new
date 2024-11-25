import 'package:flutter/material.dart';
import 'package:trova/class/NotificationsClass.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationsClass _notificationsClass = NotificationsClass();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final notifications = await _notificationsClass.fetchNotifications();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  void _markAsRead(String notificationId) async {
    await _notificationsClass.markNotificationAsRead(notificationId);
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final bool isRead = notification['status'] == 'read';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(notification['userImage']),
                  ),
                  title: Text(notification['message']),
                  subtitle: Text(notification['subtext']),
                  trailing: isRead
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : IconButton(
                          icon: const Icon(Icons.mark_email_read),
                          onPressed: () {
                            _markAsRead(notification['notificationId']);
                          },
                        ),
                );
              },
            ),
    );
  }
}
