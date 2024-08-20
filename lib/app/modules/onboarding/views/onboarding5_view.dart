import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Onboarding5View extends GetView<OnboardingController> {
  const Onboarding5View({Key? key}) : super(key: key);
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
              padding: EdgeInsets.fromLTRB(0.w, 40.h, 0.w, 35.h),
              child: Column(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppLocalizations.of(context)!.askPreviousPeriodCycle,
                      style: CustomTextStyle.extraBold(20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppLocalizations.of(context)!.askPreviousPeriodCycleDesc,
                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SfDateRangePicker(
                      controller: controller.datePickerController.value,
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle: CustomTextStyle.bold(16),
                        textAlign: TextAlign.center,
                      ),
                      minDate: DateTime.now().subtract(Duration(days: 3 * 30)),
                      maxDate: DateTime.now(),
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: 'E',
                        viewHeaderHeight: 35,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: CustomTextStyle.regular(14),
                        ),
                      ),
                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle: CustomTextStyle.bold(14),
                        todayTextStyle: CustomTextStyle.bold(14),
                        todayCellDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      navigationDirection: DateRangePickerNavigationDirection.horizontal,
                      // navigationMode: DateRangePickerNavigationMode.scroll,
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: CustomTextStyle.bold(14),
                        todayTextStyle: CustomTextStyle.bold(14),
                      ),
                      selectionTextStyle: CustomTextStyle.bold(14, color: AppColors.white),
                      todayHighlightColor: AppColors.primary,
                      rangeTextStyle: CustomTextStyle.bold(14),
                      onSelectionChanged: controller.onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.multiRange,
                      rangeSelectionColor: const Color.fromARGB(255, 254, 219, 219),
                      startRangeSelectionColor: AppColors.primary,
                      endRangeSelectionColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: CustomButton(
                text: AppLocalizations.of(context)!.next,
                onPressed: () {
                  controller.validateLastPeriod();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
