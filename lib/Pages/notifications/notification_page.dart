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
    final theme = Theme.of(context);

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
                        duration: Duration(seconds: 2),
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
                    Icon(
                      Icons.done_all,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Đọc tất cả thông báo",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
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
            ? Center(
                child: Text(
                  "Chưa đăng nhập",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              )
            : StreamBuilder<List<Map<String, dynamic>>>(
                stream: userService.getUserNotifications(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Có lỗi xảy ra",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 64,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Không có thông báo nào",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];

                      return NotificationCard(
                        id: notif["id"],
                        title: notif["title"] ?? "Thông báo",
                        message: notif["message"] ?? "",
                        icon: Icons.notifications_rounded,
                        accentColor: theme.colorScheme.primary,
                        isRead: notif["isRead"] ?? false,
                        createdAt: notif["timestamp"] != null
                            ? (notif["timestamp"] as Timestamp).toDate()
                            : DateTime.now(),
                        onTap: () async {
                          if (!(notif["isRead"] ?? false)) {
                            await markNotificationAsRead(user, notif["id"]);
                          }
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}