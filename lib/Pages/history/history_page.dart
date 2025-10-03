// history_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/widgets/historycard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/user_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userService = UserService();

    return Scaffold(
      appBar: AppBar(title: const Text('Thông Báo')),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Chưa đăng nhập"))
            : StreamBuilder<List<Map<String, dynamic>>>(
                stream: userService.getUserHistory(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(
                      color: Colors.blue,
                    ));
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
                        child: Historycard(
                          title: notif["title"] ?? "Thông báo",
                          action: notif["action"] ?? "",
                          accentColor: Colors.blue,
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
