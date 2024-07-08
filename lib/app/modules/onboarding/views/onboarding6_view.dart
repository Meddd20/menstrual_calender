import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_calendar_datepicker.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class Onboarding6View extends GetView<OnboardingController> {
  const Onboarding6View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: AppColors.white,
          leading: const BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 35.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  CustomCircularIcon(
                    iconData: Icons.crisis_alert,
                    iconSize: 35,
                    iconColor: AppColors.primary,
                    containerColor: AppColors.highlight,
                    containerSize: 30.dg,
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Enter the First Day of Your Last Period",
                    style: CustomTextStyle.heading3TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Help us calculate your pregnancy week by entering the first day of your last period.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),
                  CustomCalendarDatePicker(
                    value: [controller.lastPeriodDate.value as DateTime?],
                    onValueChanged: (dates) {
                      controller.lastPeriodDate.value = dates.isNotEmpty ? dates[0] ?? DateTime.now() : DateTime.now();
                      controller.update();
                    },
                    firstDate: DateTime.now().subtract(Duration(days: 280)),
                    lastDate: DateTime.now(),
                    calendarType: CalendarDatePicker2Type.single,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: CustomButton(
                text: "Register",
                onPressed: () {
                  Get.toNamed(Routes.REGISTER);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
