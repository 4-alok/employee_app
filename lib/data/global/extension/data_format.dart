// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

extension DateTimeString on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String get to_d_MMM_yyyy => isSameDate(DateTime.now())
      ? "Today"
      : DateFormat('d MMM yyyy').format(this);

  String get to_d_MMMc_yyyy => isSameDate(DateTime.now())
      ? "Today"
      : insert(6, ",", DateFormat('d MMM yyyy').format(this));

  String insert(int index, String char, String text) =>
      (index >= 0 && index <= text.length)
          ? text.substring(0, index) + char + text.substring(index)
          : text;
}
