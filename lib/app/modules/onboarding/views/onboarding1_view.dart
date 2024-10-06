import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_calendar_datepicker.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Onboarding1View extends GetView<OnboardingController> {
  const Onboarding1View({Key? key}) : super(key: key);
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 15.h),
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
                      AppLocalizations.of(context)!.askBirthday,
                      style: CustomTextStyle.extraBold(20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      AppLocalizations.of(context)!.askBirthdayDesc,
                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      child: CustomCalendarDatePicker(
                        value: [controller.birthday.value],
                        onValueChanged: (dates) {
                          controller.birthday.value = dates.isNotEmpty ? dates[0] ?? DateTime.now() : DateTime.now();
                          controller.update();
                        },
                        lastDate: DateTime.now().subtract(Duration(days: 365 * 13)),
                        calendarType: CalendarDatePicker2Type.single,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: CustomButton(
                text: AppLocalizations.of(context)!.next,
                onPressed: () {
                  controller.validateBirthday(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
