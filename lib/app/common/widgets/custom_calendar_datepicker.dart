import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class CustomCalendarDatePicker extends StatelessWidget {
  final List<DateTime?> value;
  final Function(List<DateTime?>) onValueChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final CalendarDatePicker2Type calendarType;

  CustomCalendarDatePicker({
    Key? key,
    required this.value,
    required this.onValueChanged,
    this.firstDate,
    this.lastDate,
    required this.calendarType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        calendarType: calendarType,
        firstDate: firstDate,
        lastDate: lastDate,
        weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
        firstDayOfWeek: 1,
        controlsHeight: 50,
        controlsTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        centerAlignModePicker: true,
        customModePickerIcon: const SizedBox(),
        selectedDayHighlightColor: Color(0xFFFF6868),
        weekdayLabelTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        dayTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      value: value,
      onValueChanged: onValueChanged,
    );
  }
}
