import 'package:intl/intl.dart';

String formatSeconds(int seconds) {
  final formatter = NumberFormat('00');
  String hours = formatter.format((seconds / 3600).floor());
  String minutes = formatter.format(((seconds % 3600) / 60).floor());
  String second = formatter.format((seconds % 60));
  return "$hours:$minutes:$second";
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}

DateTime mostRecentSunday(DateTime date) {
  return DateTime(date.year, date.month, date.day - date.weekday % 7);
}
