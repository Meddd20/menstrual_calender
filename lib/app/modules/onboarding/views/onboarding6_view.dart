import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding7_view.dart';

class Onboarding6View extends GetView<OnboardingController> {
  const Onboarding6View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(
            color: Color(0xFFFD6666),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFC7C7),
                  ),
                  child: Icon(
                    Icons.crisis_alert, // Replace with your desired icon
                    size: 35,
                    color: Color(0xFFFF6868), // Customize the icon color here
                  ),
                ),
                SizedBox(height: 25.h),
                Text(
                  "Enter your date you were born",
                  style: TextStyle(
                    fontSize: 18.sp,
                    height: 1.25,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7.h),
                Text(
                  "All the features will be available anyway",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 2.0,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                Container(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      lastDate: DateTime.now(),
                      weekdayLabels: [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ],
                      firstDayOfWeek: 1,
                      weekdayLabelTextStyle: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      controlsHeight: 50,
                      controlsTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      selectedDayHighlightColor: Color(0xFFFF6868),
                    ),
                    value: [controller.selectedDate.value as DateTime?],
                    onValueChanged: (dates) {
                      controller.lastPeriodDate.value = dates.isNotEmpty
                          ? dates[0] ?? DateTime.now()
                          : DateTime.now();
                      controller.update();
                      print(controller.lastPeriodDate.value);
                    },
                  ),
                ),
                SizedBox(height: 85.h),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => Onboarding7View());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFD6666),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: Size(Get.width, 45.h)),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.38,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
