// lib/utils/time_utils.dart
String formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return "Vừa xong";
  } else if (difference.inMinutes < 60) {
    return "${difference.inMinutes} phút trước";
  } else if (difference.inHours < 24) {
    return "${difference.inHours} giờ trước";
  } else {
    // Hiện ngày tháng năm + giờ phút
    return "${time.day.toString().padLeft(2, '0')}/"
           "${time.month.toString().padLeft(2, '0')}/"
           "${time.year} ${time.hour.toString().padLeft(2, '0')}:"
           "${time.minute.toString().padLeft(2, '0')}";
  }
}
