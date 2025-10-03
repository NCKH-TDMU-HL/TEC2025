//user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm lịch sử
  Future<void> addHistory(User user, String title, String action) async {
    await _db.collection("Users").doc(user.uid).collection("History").add({
      "uid": user.uid,
      "title": title,
      "email": user.email,
      "action": action,
      "isRead": false,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // Thêm thông báo
  Future<void> addNotification(
    User user,
    String title,
    String message,
    String type,
  ) async {
    await _db
        .collection("Users")
        .doc(user.uid)
        .collection("Notifications")
        .add({
          "uid": user.uid,
          "title": title,
          "message": message,
          "type": type,
          "isRead": false,
          "timestamp": FieldValue.serverTimestamp(),
        });
  }

  // Lấy thông báo
  Stream<List<Map<String, dynamic>>> getUserNotifications(User user) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Notifications")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "id": doc.id, // thêm id để update
              ...data,
            };
          }).toList(),
        );
  }

  // Lấy Lịch Sử
  Stream<List<Map<String, dynamic>>> getUserHistory(User user) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("History")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              "id": doc.id,
              ...data,
            };
          }).toList(),
        );
  }
}
// Đánh dấu thông báo đã đọc
Future<void> markNotificationAsRead(User user, String notificationId) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(user.uid)
      .collection("Notifications")
      .doc(notificationId)
      .update({"isRead": true});
}

// Đánh dấu đọc tất cả thông báo
Future<void> markAllNotificationsAsRead(User user) async {
  final batch = FirebaseFirestore.instance.batch();

  final querySnapshot = await FirebaseFirestore.instance
      .collection("Users")
      .doc(user.uid)
      .collection("Notifications")
      .where("isRead", isEqualTo: false)
      .get();

  for (var doc in querySnapshot.docs) {
    batch.update(doc.reference, {"isRead": true});
  }

  await batch.commit();
}

// Xóa thông báo
Future<void> deleteNotification(User user, String notificationId) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(user.uid)
      .collection("Notifications")
      .doc(notificationId)
      .delete();
}