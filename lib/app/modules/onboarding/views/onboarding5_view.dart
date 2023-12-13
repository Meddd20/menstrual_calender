import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class Onboarding5View extends GetView<OnboardingController> {
  const Onboarding5View({Key? key}) : super(key: key);
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
                  "When did your last period start?",
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
                  "Predict your next period from your last period",
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
                      firstDate:
                          DateTime.now().subtract(Duration(days: 3 * 30)),
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
                      calendarType: CalendarDatePicker2Type.multi,
                      controlsHeight: 50,
                      controlsTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      selectedDayHighlightColor: Color(0xFFFF6868),
                      selectableDayPredicate: (DateTime day) {
                        // Check if the selected date is already in the periodHistory array
                        if (controller.periodHistory.contains(day)) {
                          // Allow unchoosing by always returning true
                          return true;
                        } else {
                          for (DateTime selectedDate
                              in controller.periodHistory) {
                            // Check if the selected date is within 20 days of any picked date
                            if (day.isAfter(selectedDate
                                    .subtract(Duration(days: 20))) &&
                                day.isBefore(
                                    selectedDate.add(Duration(days: 20)))) {
                              // The selected date is not allowed if it's within 20 days of any picked date
                              return false;
                            }
                          }
                          // Allow selection if it passes the restriction for all picked dates
                          return true;
                        }
                      },
                    ),
                    value: [controller.selectedDate.value as DateTime?],
                    onValueChanged: (dates) {
                      dates.removeWhere((date) => date == DateTime.now());
                      controller.periodHistory.value =
                          dates.map((date) => date ?? DateTime.now()).toList();
                      controller.update();
                      print(controller.periodHistory);
                    },
                  ),
                ),
                SizedBox(height: 85.h),
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.REGISTER);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFD6666),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: Size(Get.width, 45.h)),
                  child: Text(
                    "Calculate",
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
