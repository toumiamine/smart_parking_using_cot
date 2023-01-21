import 'package:intl/intl.dart';

class CalendarData {
  final String name;
  final DateTime date;
  final String position;

  String getDate() {
    final formatter = DateFormat('kk:mm');

    return formatter.format(date);
  }

  CalendarData({
    required this.name,
    required this.date,
    required this.position,
  });
}

