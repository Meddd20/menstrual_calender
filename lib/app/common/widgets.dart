import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
          borderRadius: BorderRadius.circular(10),
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
  final double containerSize;

  CustomCircularIconContainer({
    required this.iconData,
    required this.iconSize,
    required this.iconColor,
    required this.containerColor,
    required this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: containerSize,
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
          background: AppColors.highlight.withOpacity(0.3),
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
  final void Function(String)? onChanged;
  final String? hintText;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.hintText,
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
        hintText: hintText,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
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

class CustomTabBar extends StatelessWidget {
  final Function(int) onTap;
  final TabController controller;

  CustomTabBar({required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFFFefeff0),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.white,
        ),
        dividerColor: AppColors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(2),
        labelColor: Colors.black,
        onTap: onTap,
        unselectedLabelColor: Colors.grey.shade600,
        tabs: [
          Tab(
            child: Text(
              '30 Days',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              '3 Months',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              '6 Months',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Tab(
            child: Text(
              '1 Year',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDougnutChart extends StatelessWidget {
  final List<MapEntry<String, dynamic>> dataSource;
  final Color Function(MapEntry<String, dynamic>, int) pointColorMapper;
  final List<Color> colorPalette;

  CustomDougnutChart(
      {required this.dataSource,
      required this.pointColorMapper,
      required this.colorPalette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: Get.width,
      height: Get.height * 0.37,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<MapEntry<String, dynamic>, String>(
            dataSource: dataSource,
            xValueMapper: (MapEntry<String, dynamic> entry, _) => entry.key,
            yValueMapper: (MapEntry<String, dynamic> entry, _) =>
                parseDouble(entry.value),
            dataLabelMapper: (MapEntry<String, dynamic> entry, _) =>
                '${entry.value}',
            enableTooltip: true,
            selectionBehavior: SelectionBehavior(enable: true),
            explode: true,
            // explodeIndex: 2,
            pointColorMapper: pointColorMapper,
            explodeOffset: '10%',
            radius: '95%',
            // dataLabelSettings: DataLabelSettings(
            //   isVisible: true,
            //   labelPosition: ChartDataLabelPosition.inside,
            //   connectorLineSettings: ConnectorLineSettings(
            //     type: ConnectorType.line,
            //   ),
            //   labelAlignment: ChartDataLabelAlignment.middle,
            // ),
          ),
        ],
        legend: Legend(
          isVisible: true,
          position: LegendPosition.right,
          isResponsive: true,
          toggleSeriesVisibility: false,
          legendItemBuilder:
              (String name, dynamic series, dynamic point, int index) {
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPalette[index],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("$name :"),
                  SizedBox(width: 10),
                  Text(
                    (point.y.toInt()).toString(),
                  ),
                ],
              ),
            );
          },
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

class CustomDateLook extends StatelessWidget {
  final MapEntry<String, dynamic> entry;

  CustomDateLook({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
              // border: Border.all(width: 1),
              ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 24.sp,
                            height: 1,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 2,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 80,
                    width: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.highlight,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', ''),
                      overflow: TextOverflow.visible,
                      style: CustomTextStyle.captionTextStyle(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
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

class AddPeriodBottomSheetWidget extends StatelessWidget {
  final void Function()? closeModalBottomSheet;
  final String title;
  final Obx startDate;
  final Obx endDate;
  final void Function()? addPeriodOnPressedButton;
  final List<DateTime?> calenderValue;
  final dynamic Function(List<DateTime?>) calenderOnValueChanged;
  final bool isEdit;

  AddPeriodBottomSheetWidget({
    required this.closeModalBottomSheet,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.addPeriodOnPressedButton,
    required this.calenderValue,
    required this.calenderOnValueChanged,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
      child: Column(
        children: [
          Container(
            height: 4.h,
            width: 32.w,
            margin: EdgeInsets.only(top: 16.h),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                              color: Color(0xFFFD6666),
                            ),
                            onPressed: closeModalBottomSheet,
                          )
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Update the start and end dates of a specific time period for precise and current tracking.",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: startDate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "End Date",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: endDate,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Icon(Iconsax.calendar),
                  ],
                ),
              )
            ],
          ),
          CustomCalendarDatePicker(
            value: calenderValue,
            onValueChanged: calenderOnValueChanged,
            lastDate: DateTime.now(),
            calendarType: CalendarDatePicker2Type.range,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: addPeriodOnPressedButton,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minimumSize: Size(Get.width, 45.h)),
            child: Text(
              "Add Period",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.38,
                color: Colors.white,
              ),
            ),
          ),
          isEdit ? SizedBox(height: 5.h) : SizedBox.shrink(),
          if (isEdit)
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: Colors.transparent,
                minimumSize: Size(Get.width, Get.height * 0.06),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  letterSpacing: 0.38,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}

class CustomIconCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const CustomIconCard({
    required this.icon,
    required this.text,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.highlight,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withOpacity(0.74),
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                // letterSpacing: 0.38,
              ),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}

class CustomCardNextCycle extends StatelessWidget {
  final Color cardColor;
  final String cardHeader;
  final String cardBody;
  final String cardFooter;
  final String imagePath;

  CustomCardNextCycle({
    required this.cardColor,
    required this.cardHeader,
    required this.cardBody,
    required this.cardFooter,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Container(
        width: Get.width - 100,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                child: Image.asset(imagePath),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Text(
                      cardHeader,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      cardBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFF6868),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.38,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      cardFooter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.74),
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.38,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardPredictionCycle extends StatelessWidget {
  final Color containerColor;
  final Color primaryColor;
  final String daysLeft;
  final String predictionType;
  final String datePrediction;
  final IconData icons;

  CustomCardPredictionCycle({
    required this.containerColor,
    required this.primaryColor,
    required this.daysLeft,
    required this.predictionType,
    required this.datePrediction,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 115.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: containerColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomCircularIconContainer(
                    iconData: icons,
                    iconSize: 25,
                    iconColor: primaryColor,
                    containerColor: AppColors.white,
                    containerSize: 15.dg,
                  ),
                  Text(
                    daysLeft,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                predictionType,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                datePrediction,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

double parseDouble(dynamic value) {
  if (value != null) {
    try {
      return double.parse(value.toString());
    } catch (e) {
      print("Error parsing double: $e");
    }
  }
  return 0.0;
}

class MyTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
