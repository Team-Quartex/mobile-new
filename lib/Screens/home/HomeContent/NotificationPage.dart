import 'package:flutter/material.dart';
import 'package:trova/class/Notification_Class.dart';
import 'package:trova/widget/NotificationWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationClass _notificationClass;
  late Future<List<Map<String, dynamic>>> _notifications;
  Map<int, Map<String, String>> _userDetails = {};

  @override
  void initState() {
    super.initState();
    _notificationClass = NotificationClass();
    _notifications = _notificationClass.getNotifications();
  }

  Future<void> fetchUserDetails(int userId) async {
    if (!_userDetails.containsKey(userId)) {
      final response = await http.get(
        Uri.parse("http://172.20.10.4/userDetails?userId=$userId"),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        _userDetails[userId] = {
          'username': userData['username'],
          'profilepic': userData['profilepic'],
        };
        setState(() {});
      } else {
      }
    }
  }

  void _markAsRead(int notifyId) async {
    final response = await http.post(
      Uri.parse("http://172.20.10.4/viewnotification"),
      body: json.encode({
        'notifyid': notifyId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        _notifications = _notificationClass.getNotifications();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.body}')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
