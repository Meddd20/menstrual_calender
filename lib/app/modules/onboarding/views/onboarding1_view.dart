import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding2_view.dart';

class Onboarding1View extends GetView<OnboardingController> {
  const Onboarding1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xFFf9f8fb),
          surfaceTintColor: Color(0xFFf9f8fb),
          leading: const BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h),
                  CustomCircularIconContainer(
                    iconData: Icons.crisis_alert,
                    iconSize: 35,
                    iconColor: AppColors.primary,
                    containerColor: AppColors.highlight,
                    containerSize: 30.dg,
                  ),
                  SizedBox(height: 25.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Enter your date you were born",
                      style: CustomTextStyle.heading3TextStyle(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "All the features will be available anyway",
                      style: CustomTextStyle.bodyTextStyle(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    child: CustomCalendarDatePicker(
                      value: [controller.birthday.value],
                      onValueChanged: (dates) {
                        controller.birthday.value = dates.isNotEmpty
                            ? dates[0] ?? DateTime.now()
                            : DateTime.now();
                        controller.update();
                        print(controller.birthday.value);
                      },
                      lastDate: DateTime.now(),
                      calendarType: CalendarDatePicker2Type.single,
                    ),
                  ),
                  SizedBox(height: 85.h),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                child: CustomColoredButton(
                  text: "Next",
                  onPressed: () {
                    controller.validateBirthday();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
