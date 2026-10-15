import 'package:intl/intl.dart';

class AppFormatters {
  static String formatDate(DateTime dateTime) {
    return DateFormat('d MMM yyyy, HH:mm').format(dateTime);
  }

  static String formatScore(int score) {
    return '$score pt';
  }

  static String formatPercentage(int correct, int total) {
    if (total == 0) return '0%';
    final percentage = ((correct / total) * 100).round();
    return '$percentage%';
  }
}
