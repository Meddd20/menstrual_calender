import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

class CustomColoredButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomColoredButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFD6666),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        minimumSize: Size(Get.width, 45.h),
      ),
      child: Text(
        text,
        style: CustomTextStyle.buttonTextStyle(color: Colors.white),
      ),
    );
  }
}

class CustomTransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTransparentButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.transparent,
        minimumSize: Size(Get.width, 45.h),
      ),
      child: Text(
        text,
        style: CustomTextStyle.buttonTextStyle(),
      ),
    );
  }
}

class CustomCircularIconContainer extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final Color containerColor;

  CustomCircularIconContainer({
    required this.iconData,
    required this.iconSize,
    required this.iconColor,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.dg,
      backgroundColor: containerColor,
      child: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}

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

class CustomCupertinoPicker extends StatelessWidget {
  final FixedExtentScrollController scrollController;
  final List<Widget> children;
  final Function(int) onSelectedItemChanged;

  CustomCupertinoPicker({
    required this.scrollController,
    required this.children,
    required this.onSelectedItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      child: CupertinoPicker(
        itemExtent: 45,
        magnification: 1.22,
        looping: true,
        useMagnifier: true,
        scrollController: scrollController,
        children: children,
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: Color(0xFFFFE6E6).withOpacity(0.3),
        ),
        onSelectedItemChanged: onSelectedItemChanged,
      ),
    );
  }
}

class CustomCupertinoDateTimePicker extends StatelessWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime initialDateTime;

  CustomCupertinoDateTimePicker(
      {required this.onDateTimeChanged, required this.initialDateTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      child: CupertinoDatePicker(
        onDateTimeChanged: onDateTimeChanged,
        initialDateTime: initialDateTime,
        minimumDate: DateTime.now(),
        use24hFormat: true,
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          gapPadding: 4.0,
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

class CustomPinInput extends StatelessWidget {
  final TextEditingController controller;
  final int length;
  final bool showCursor;

  const CustomPinInput({
    required this.controller,
    required this.length,
    this.showCursor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Pinput(
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      controller: controller,
      length: length,
      showCursor: showCursor,
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      submittedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(234, 239, 243, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  CustomChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool isSelected) {
        onSelected();
      },
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: Color(0xFF34C2C1),
      showCheckmark: false,
    );
  }
}

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  CustomFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: Color(0xFF34C2C1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      showCheckmark: false,
    );
  }
}

class CustomCalendar extends StatelessWidget {
  final bool isExpandable;
  final Color? bottomBarColor;
  final Color? bottomBarArrowColor;
  final TextStyle? bottomBarTextStyle;
  final String? expandableDateFormat;
  final Function(DateTime selectedDate)? onDateSelected;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;

  CustomCalendar({
    Key? key,
    required this.isExpandable,
    this.bottomBarColor,
    this.bottomBarArrowColor,
    this.bottomBarTextStyle,
    this.expandableDateFormat,
    required this.onDateSelected,
    required this.dayBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Calendar(
      startOnMonday: true,
      weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      eventDoneColor: Colors.green,
      selectedColor: Colors.pink,
      selectedTodayColor: Colors.amber,
      todayColor: Colors.blue,
      locale: 'en_US',
      todayButtonText: 'Today',
      allDayEventText: 'All Day',
      multiDayEndText: 'End',
      defaultDayColor: Colors.black,
      isExpanded: false,
      initialDate: DateTime.now(),
      isExpandable: isExpandable,
      bottomBarColor: bottomBarColor,
      bottomBarArrowColor: bottomBarArrowColor,
      bottomBarTextStyle: bottomBarTextStyle,
      expandableDateFormat: expandableDateFormat,
      onDateSelected: onDateSelected,
      dayBuilder: (context, day) {
        return dayBuilder(context, day);
      },
      displayMonthTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      datePickerType: DatePickerType.hidden,
      dayOfWeekStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
      showEvents: false,
    );
  }
}
