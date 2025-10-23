  import 'package:cloud_firestore/cloud_firestore.dart';

String formatChatTime(Timestamp time) {
    final now = Timestamp.now();
    final diff = now.toDate().difference(time.toDate());
    final date = time.toDate();

    if (diff.inDays == 0) {
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (diff.inDays == 1) {
      return "Yesterday";
    } else if (diff.inDays < 7) {
      const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
      return weekdays[date.weekday % 7];
    } else if (now.toDate().year == date.year) {
      return "${date.day}/${date.month}";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
