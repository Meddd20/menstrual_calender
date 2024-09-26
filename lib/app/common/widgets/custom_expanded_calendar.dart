import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomExpandedCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final Function(CalendarFormat calendarFormat)? onFormatChanged;
  final bool formatButtonVisible;
  final BoxDecoration headerStyle;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged;
  final bool Function(DateTime day) selectedDayPredicate;
  final Widget Function(BuildContext context, DateTime day, DateTime focusedDay)? defaultBuilder;
  final Widget Function(BuildContext, DateTime, List<Object?>)? markerBuilder;
  final CalendarFormat calendarFormat;

  const CustomExpandedCalendar({
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.onFormatChanged,
    this.formatButtonVisible = false,
    this.headerStyle = const BoxDecoration(),
    required this.onDaySelected,
    required this.onPageChanged,
    required this.selectedDayPredicate,
    this.defaultBuilder,
    this.markerBuilder,
    required this.calendarFormat,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      availableCalendarFormats: {
        CalendarFormat.month: AppLocalizations.of(context)!.month,
        CalendarFormat.week: AppLocalizations.of(context)!.week,
      },
      calendarFormat: calendarFormat,
      onFormatChanged: onFormatChanged,
      startingDayOfWeek: StartingDayOfWeek.monday,
      locale: StorageService().getLanguage() == "en" ? 'en_US' : 'id_ID',
      onDaySelected: (selectedDay, focusedDay) {
        onDaySelected(selectedDay, focusedDay);
      },
      onPageChanged: (focusedDay) {
        onPageChanged(focusedDay);
      },
      selectedDayPredicate: (day) => selectedDayPredicate(day),
      rowHeight: 50,
      daysOfWeekHeight: 25.0,
      calendarStyle: CalendarStyle(
        cellMargin: EdgeInsets.all(6),
        outsideDaysVisible: false,
        isTodayHighlighted: true,
        rangeStartDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        withinRangeDecoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        decoration: headerStyle,
        formatButtonVisible: formatButtonVisible,
        leftChevronVisible: true,
        rightChevronVisible: true,
        titleCentered: true,
        titleTextStyle: CustomTextStyle.bold(16),
        headerMargin: EdgeInsets.only(bottom: 10),
        formatButtonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        formatButtonTextStyle: CustomTextStyle.bold(14),
        formatButtonPadding: EdgeInsets.all(6.0),
      ),
      availableGestures: AvailableGestures.all,
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          return Center(
            child: Text(
              DateFormat.E().format(day),
              style: CustomTextStyle.regular(14),
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          if (defaultBuilder != null) {
            return defaultBuilder!(context, day, focusedDay);
          } else {
            return Container(
              child: Center(
                child: Text(
                  '${day.day}',
                  style: CustomTextStyle.bold(16),
                ),
              ),
            );
          }
        },
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: CustomTextStyle.bold(16, color: Colors.white),
              ),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: CustomTextStyle.bold(16, color: Colors.white),
              ),
            ),
          );
        },
        markerBuilder: (context, day, events) {
          if (markerBuilder != null) {
            return markerBuilder!(context, day, events);
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
