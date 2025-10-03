import 'package:flutter/material.dart';
import '../../util/time_utils.dart';
import '../../service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationCard extends StatelessWidget {
  final String id;
  final String title;
  final String message;
  final IconData? icon;
  final Color? accentColor;
  final VoidCallback? onTap;
  final bool isRead;
  final DateTime createdAt;

  const NotificationCard({
    super.key,
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.icon,
    this.accentColor,
    this.onTap,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = accentColor ?? theme.primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(16),
        color: isRead
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                if (icon != null) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                ],

                // Content
                Expanded(
                  child: Stack(
                    children: [
                      // Title + Message + Time
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w500
                                        : FontWeight.w600,
                                    color: isRead
                                        ? theme.colorScheme.onSurface
                                              .withValues(alpha: 0.7)
                                        : theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: isRead ? 0.4 : 0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatTime(createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(
                                            alpha: isRead ? 0.4 : 0.5,
                                          ),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              if (onTap != null)
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),

                      // Dấu 3 chấm góc phải trên
                      Positioned(
                        top: 0,
                        right: -0,
                        child: PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert),
                          offset: const Offset(0, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) async {
                            if (value == 'mark_no_read') {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await markNotificationAsRead(user, id);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Đã đánh dấu thông báo là đã đọc",
                                      ),
                                    ),
                                  );
                                }
                              }
                            } else if (value == 'delete') {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await deleteNotification(user, id);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Đã xóa thông báo"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'mark_no_read',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.done_all,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Đọc thông báo",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.delete_outline,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Xóa thông báo",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
