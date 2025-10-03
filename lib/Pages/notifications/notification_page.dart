// notification_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/notificationcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/user_service.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông Báo"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) async {
              if (value == 'mark_all') {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await markAllNotificationsAsRead(user);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Đã đánh dấu tất cả thông báo là đã đọc"),
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'mark_all',
                child: Row(
                  children: [
                    const Icon(Icons.done_all, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "Đọc tất cả thông báo",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Chưa đăng nhập"))
            : StreamBuilder<List<Map<String, dynamic>>>(
                stream: userService.getUserNotifications(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Không có thông báo nào"));
                  }

                  final notifications = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];

                      return GestureDetector(
                        onTap: () {
                          markNotificationAsRead(user, notif["id"]);
                        },
                        child: NotificationCard(
                          id: notif["id"],
                          title: notif["title"] ?? "Thông báo",
                          message: notif["message"] ?? "",
                          accentColor: Colors.blue,
                          isRead: notif["isRead"] ?? false,
                          createdAt: notif["timestamp"] != null
                              ? (notif["timestamp"] as Timestamp).toDate()
                              : DateTime.now(),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
