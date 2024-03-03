import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

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
            color: AppColors.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
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
                  "When did your last period start?",
                  style: CustomTextStyle.heading3TextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 7.h),
                Text(
                  "Predict your next period from your last period",
                  style: CustomTextStyle.bodyTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                SfDateRangePicker(
                  controller: controller.datePickerController.value,
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle: CustomTextStyle.headerCalenderTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  minDate: DateTime.now().subtract(Duration(days: 3 * 30)),
                  maxDate: DateTime.now(),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    dayFormat: 'E',
                    viewHeaderHeight: 35,
                    viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: CustomTextStyle.weekCalenderTextStyle(),
                    ),
                  ),
                  yearCellStyle: DateRangePickerYearCellStyle(
                    textStyle: CustomTextStyle.headerCalenderTextStyle(),
                    todayTextStyle: CustomTextStyle.headerCalenderTextStyle(),
                    todayCellDecoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    textStyle: CustomTextStyle.monthlyCalenderTextStyle(),
                    todayTextStyle: CustomTextStyle.monthlyCalenderTextStyle(),
                  ),
                  selectionTextStyle:
                      CustomTextStyle.selectionCalenderTextStyle(),
                  todayHighlightColor: AppColors.primary,
                  rangeTextStyle: CustomTextStyle.monthlyCalenderTextStyle(),
                  onSelectionChanged: controller.onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.multiRange,
                  rangeSelectionColor: AppColors.highlight,
                  startRangeSelectionColor: AppColors.primary,
                  endRangeSelectionColor: AppColors.primary,
                ),
                SizedBox(height: 120.h),
                CustomColoredButton(
                  text: "Calculate",
                  onPressed: () {
                    Get.toNamed(Routes.REGISTER);
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
