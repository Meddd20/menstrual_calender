import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

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
        controlsTextStyle: CustomTextStyle.bold(15),
        centerAlignModePicker: true,
        customModePickerIcon: const SizedBox(),
        selectedDayHighlightColor: Color(0xFFFF6868),
        weekdayLabelTextStyle: CustomTextStyle.regular(14),
        dayTextStyle: CustomTextStyle.bold(16),
        selectedDayTextStyle: CustomTextStyle.bold(16, color: Colors.white),
        todayTextStyle: CustomTextStyle.bold(16),
        monthTextStyle: CustomTextStyle.regular(14),
        selectedMonthTextStyle: CustomTextStyle.bold(14, color: Colors.white),
        disabledDayTextStyle: CustomTextStyle.regular(16, color: Colors.black.withOpacity(0.6)),
      ),
      value: value,
      onValueChanged: onValueChanged,
    );
  }
}
