import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding7_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

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
            color: AppColors.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),
                CustomCircularIconContainer(
                  iconData: Icons.crisis_alert,
                  iconSize: 35,
                  iconColor: AppColors.primary,
                  containerColor: AppColors.highlight,
                ),
                SizedBox(height: 25.h),
                Text(
                  "Enter your first day of your last menstruation",
                  style: CustomTextStyle.heading3TextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7.h),
                Text(
                  "All the features will be available anyway",
                  style: CustomTextStyle.bodyTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                CustomCalendarDatePicker(
                  value: [controller.selectedDate.value as DateTime?],
                  onValueChanged: (dates) {
                    controller.lastPeriodDate.value = dates.isNotEmpty
                        ? dates[0] ?? DateTime.now()
                        : DateTime.now();
                    controller.update();
                    print(controller.lastPeriodDate.value);
                  },
                  lastDate: DateTime.now(),
                  calendarType: CalendarDatePicker2Type.single,
                ),
                SizedBox(height: 55.h),
                CustomColoredButton(
                  text: "Next",
                  onPressed: () {
                    Get.to(() => Onboarding7View());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
