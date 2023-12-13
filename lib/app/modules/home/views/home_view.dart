import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/daily_log_view.dart';
import 'package:periodnpregnancycalender/app/widgets/custom_border_card.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PageController _pageController =
        PageController(viewportFraction: 0.8);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: AppBar(
              title: Text(
                'Your cycle',
                style: TextStyle(
                  fontFamily: "Popins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.notification),
                )
              ],
              centerTitle: true,
              elevation: 0.0,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Align(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Calendar(
                    startOnMonday: true,
                    weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    eventsList: controller.getMenstruationCycle(),
                    isExpandable: true,
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
                    datePickerType: DatePickerType.hidden,
                    dayOfWeekStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                    showEvents: false,
                    onDateSelected: (DateTime selectedDate) {
                      controller.setSelectedDate(selectedDate);
                      print("tes ${controller.selectedDate}");
                    },
                    dayBuilder: (BuildContext context, DateTime day) {
                      bool isSelectedDay =
                          controller.selectedDate?.day == day.day &&
                              controller.selectedDate?.month == day.month &&
                              controller.selectedDate?.year == day.year;

                      bool isSpecialDate1 =
                          day.isAfter(DateTime(2023, 10, 1)) &&
                              day.isBefore(DateTime(2023, 10, 11));

                      bool isSpecialDate2 =
                          day.isAfter(DateTime(2023, 11, 1)) &&
                              day.isBefore(DateTime(2023, 11, 11));

                      bool isInCurrentMonth =
                          day.month == controller.selectedDate?.month;

                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelectedDay
                              ? Colors.pink
                              : isSpecialDate1
                                  ? Colors.blue
                                  : isSpecialDate2
                                      ? Colors.green
                                      : Colors.transparent,
                          border: Border.all(
                            color: isSelectedDay
                                ? Colors.pink
                                : Colors.transparent,
                            width: 3.0,
                            style: isSelectedDay
                                ? BorderStyle.solid
                                : BorderStyle.none,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isSelectedDay
                                  ? Colors.white
                                  : isInCurrentMonth
                                      ? Colors.black
                                      : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: Get.width,
                    height: 180.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFD7DF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Expanded(
                              child: Container(
                                width: Get.width - 100,
                                child: Text(
                                  "${DateFormat('MMMM, dd yyyy').format(controller.selectedDate!)}",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    height: 2.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: Get.width,
                            child: Text(
                              "Current cycle",
                              style: TextStyle(
                                fontSize: 14.sp,
                                // height: 2.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            width: Get.width,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4',
                                    style: TextStyle(
                                      color: Color(0xFF090A0A),
                                      fontSize: 24,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0.06,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'th',
                                    style: TextStyle(
                                      color: Color(0xFF090A0A),
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      height: 0.09,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' day of the cycle',
                                    style: TextStyle(
                                      color: Color(0xFF090A0A),
                                      fontSize: 20,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 0.12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: Get.width,
                            child: Text(
                              "Low chances of getting pregnant",
                              style: TextStyle(
                                fontSize: 16.sp,
                                height: 2.0,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => DailyLogView());
                    },
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.white.withOpacity(0.1),
                      side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(Get.width, 52.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.add_square4,
                          color: Color(0xFFFF6868),
                          size: 24,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'How are you feeling today?',
                          style: TextStyle(
                            color: Color(0xFF090A0A),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Text(
                    'Next Cycle',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Container(
                    height: 150.h,
                    child: ListView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: CustomBorderCard(
                            width: Get.width - 100,
                            height: double.infinity,
                            color: Color(0xFFFFD7DF),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    child: Image.asset(
                                      "assets/2bb0bcaf2c98e3d209d65f244fe05400.png",
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        Text(
                                          'Next period',
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
                                          'Dec 09',
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
                                          '(25 Days Left)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.74),
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: CustomBorderCard(
                            width: Get.width - 100,
                            height: double.infinity,
                            color: Color(0x7FA5F9FF),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    child: Image.asset(
                                      "assets/c05bebf624f24e4c75f0a2c86c84ef88.png",
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        Text(
                                          'Next ovulation',
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
                                          'Nov 25',
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
                                          '(11 Days Left)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.7400000095367432),
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: CustomBorderCard(
                            width: Get.width - 100,
                            height: double.infinity,
                            color: Color(0xFFC6FCE5),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    child: Image.asset(
                                      "assets/8b680d9c9dbe5efd752b6546c263ce23.png",
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        Text(
                                          'Fertile days',
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
                                          '23 Nov - 27 Nov',
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
                                          '(9 Days Left)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.7400000095367432),
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
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: CustomBorderCard(
                            width: Get.width - 100,
                            height: double.infinity,
                            color: Color(0xFFFFE69E),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0, right: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    child: Image.asset(
                                      "assets/ff118d5b4ec2622460cd6bc27a27aeb0.png",
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        Text(
                                          'Safe days',
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
                                          '17 Nov - 22 Nov',
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
                                          '(3 Days Left)',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(
                                                0.7400000095367432),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
