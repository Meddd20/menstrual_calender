import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_calendar_datepicker.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
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

  CustomDougnutChart({required this.dataSource, required this.pointColorMapper, required this.colorPalette});

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
            yValueMapper: (MapEntry<String, dynamic> entry, _) => parseDouble(entry.value),
            dataLabelMapper: (MapEntry<String, dynamic> entry, _) => '${entry.value}',
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
          legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
            return Container(
              width: 110,
              // height: 30,
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
                  Expanded(
                    child: Text(
                      "$name ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
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
                      entry.value.toString().replaceAll('[', '').replaceAll(']', ''),
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
  final String buttonCaption;

  AddPeriodBottomSheetWidget({
    required this.closeModalBottomSheet,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.addPeriodOnPressedButton,
    required this.calenderValue,
    required this.calenderOnValueChanged,
    required this.buttonCaption,
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
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: Size(Get.width, 45.h)),
            child: Text(
              buttonCaption,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  CustomCircularIcon(
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

class Ui {
  static GetSnackBar SuccessSnackBar({String title = 'Success', String message = ''}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: Text(
        title.tr,
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: AppColors.white,
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: const Color.fromARGB(255, 179, 231, 181),
        child: Icon(Icons.check_circle, size: 24, color: Colors.green),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 1500),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error', String message = ''}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(
        title.tr,
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: AppColors.white,
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: Color.fromARGB(255, 240, 216, 216),
        child: Icon(Icons.error, size: 24, color: Colors.red),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 1500),
    );
  }
}
