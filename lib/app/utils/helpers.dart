import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

/// Formats the date as 'yyyy-MM-dd'.
/// Example: '2024-09-04'
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

/// Parses a date string in 'yyyy-MM-dd' format and returns a DateTime object.
/// Example: '2024-09-04' -> DateTime(2024, 09, 04)
DateTime formatDateStr(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}

/// Formats the date and time as 'yyyy-MM-dd HH:mm:ss'.
/// Example: '2024-09-04 14:30:00'
String formatDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

/// Formats the date and time as 'EEEE, d MMMM yyyy HH:mm'.
/// Example: 'Wednesday, 4 September 2024 14:30'
String formatLongDateTime(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  return DateFormat('EEEE, d MMMM yyyy HH:mm').format(date);
}

/// Formats the date as 'dd.MM HH:mm'.
/// Example: '04.09 14:30'
String formatDateToDayHour(String datetime) {
  var formatDatetime = DateTime.parse(datetime);
  return DateFormat('dd.MM HH:mm').format(formatDatetime);
}

/// Formats the date as 'MMM dd, yyyy'.
/// Example: 'Sep 04, 2024'
String formatDateWithMonthName(DateTime date) {
  return DateFormat('MMM dd, yyyy').format(date);
}

/// Parses a date string and formats it as 'MMM dd, yyyy'.
/// Example: '2024-09-04' -> 'Sep 04, 2024'
String formatDateStrWithMonthName(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('MMM dd, yyyy').format(date);
}

/// Formats the date as 'MMMM dd'.
/// Example: 'September 04'
String formatDateToMonthDay(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('MMMM dd').format(date);
}

/// Formats the date as 'MMM dd'.
/// Example: 'Sep 04'
String formatDateToShortMonthDay(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  return DateFormat('MMM dd').format(date);
}

/// Formats the date as 'EEEE, dd MMMM yyyy'.
/// Example: 'Wednesday, 04 September 2024'
String formatDayOfWeekDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('EEEE, dd MMMM yyyy').format(date);
}

/// Formats the time as 'HH:mm'.
/// Example: '14:30'
String formatHourMinute(DateTime time) {
  return DateFormat('HH:mm').format(time);
}

/// Formats the date as 'yyyy/MM/dd'.
/// Example: '2024/09/04'
String formatYearMonthDay(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('yyyy/MM/dd').format(date);
}

/// Formats the date as 'dd.MM'.
/// Example: '04.09'
String formatShortDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('dd.MM').format(date);
}

/// Formats the time as 'HH:mm:ss'.
/// Example: '14:30:00'
String formatHourMinuteSecond(String timeString) {
  DateTime time = DateTime.parse(timeString);
  return DateFormat('HH:mm:ss').format(time);
}

/// Formats the date as 'MMMM, dd yyyy'.
/// Example: 'September, 04 2024'
String formatMonthDayYear(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('MMMM, dd yyyy').format(date);
}

/// Formats the date as 'dd'.
/// Example: '04'
String formatToDay(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('dd').format(date);
}

/// Formats the date as 'MMM'.
/// Example: 'Sep'
String formatToMonth(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('MMM').format(date);
}

/// Formats the date as 'yyyy'.
/// Example: '2024'
String formatToYear(String dateString) {
  DateTime date = DateTime.parse(dateString);
  return DateFormat('yyyy').format(date);
}

/// Formats the time as 'HH:mm a' (12-hour format with AM/PM).
/// Example: '02:30 PM'
String formatTimeWithAmPm(DateTime date) {
  return DateFormat('HH:mm a').format(date);
}

/// Formats the date as 'dd, MMMM yyyy'.
/// Example: '04, September 2024'
String formatFullDate(DateTime dateTime) {
  return DateFormat('dd, MMMM yyyy').format(dateTime);
}

class MyTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
