// import 'package:flutter/material.dart';
// import 'package:trova/class/Notification_Class.dart';
// import 'package:trova/class/image_location.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   final NotificationClass _notificationsClass = NotificationClass();
//   List<Map<String, dynamic>> _notifications = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchNotifications();
//   }
//
//   Future<void> _fetchNotifications() async {
//     final notifications = await _notificationsClass.getNotifications();
//     setState(() {
//       _notifications = notifications;
//       _isLoading = false;
//     });
//   }
//
//   void _markAsRead(String notificationId) async {
//     await _notificationsClass.markAsRead(int.parse(notificationId));
//     _fetchNotifications();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = _notifications[index];
//                 final bool isRead = notification['status'] == 'read';
//
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: NetworkImage(ImageLocation().imageUrl(notification['profilepic'].toString())),
//                   ),
//                   title: Text(notification['name']),
//                   subtitle: Text("Start Following you"),
//                   trailing: isRead
//                       ? const Icon(Icons.check_circle, color: Colors.green)
//                       : IconButton(
//                           icon: const Icon(Icons.mark_email_read),
//                           onPressed: () {
//                             _markAsRead(notification['notificationId']);
//                           },
//                         ),
//                 );
//               },
//             ),
//     );
//   }
// }
