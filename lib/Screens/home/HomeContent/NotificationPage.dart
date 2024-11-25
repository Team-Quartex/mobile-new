import 'package:flutter/material.dart';
import 'package:trova/class/NotificationService.dart';
import 'package:trova/model/NotificationModel.dart';
import 'package:trova/widget/NotificationCard.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<NotificationModel>> _notifications;

  @override
  void initState() {
    super.initState();
    final notificationService = NotificationService();
    _notifications = notificationService.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return NotificationCard(notification: notification);
              },
            );
          } else {
            return const Center(child: Text('No notifications available'));
          }
        },
      ),
    );
  }
}
