import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class Onboarding5View extends GetView<OnboardingController> {
  const Onboarding5View({Key? key}) : super(key: key);
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
            Column(
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
                    "When did your last period start?",
                    style: CustomTextStyle.heading3TextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 7.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Predict your next period from your last period",
                    style: CustomTextStyle.bodyTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SfDateRangePicker(
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
                    navigationDirection:
                        DateRangePickerNavigationDirection.horizontal,
                    // navigationMode: DateRangePickerNavigationMode.scroll,
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: CustomTextStyle.monthlyCalenderTextStyle(),
                      todayTextStyle:
                          CustomTextStyle.monthlyCalenderTextStyle(),
                    ),
                    selectionTextStyle:
                        CustomTextStyle.selectionCalenderTextStyle(),
                    todayHighlightColor: AppColors.primary,
                    rangeTextStyle: CustomTextStyle.monthlyCalenderTextStyle(),
                    onSelectionChanged: controller.onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.multiRange,
                    rangeSelectionColor:
                        const Color.fromARGB(255, 254, 219, 219),
                    startRangeSelectionColor: AppColors.primary,
                    endRangeSelectionColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                child: CustomColoredButton(
                  text: "Calculate",
                  onPressed: () {
                    controller.validateLastPeriod();
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
