import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

DateTime formatDateStr(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}

DateTime parseDateTimeStr(String dateTimeStr) {
  return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeStr);
}

String formatToDayHour(String datetime) {
  var formatDatetime = DateTime.parse(datetime);
  return DateFormat('dd.MM HH:mm').format(formatDatetime);
}

class MyTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
