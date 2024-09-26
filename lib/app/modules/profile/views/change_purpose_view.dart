import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_expanded_calendar.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/profile_controller.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePurposeView extends GetView<ProfileController> {
  const ChangePurposeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final box = GetStorage();
    return box.read("isPregnant") == "0" ? changePurposeToPregnancy(context) : changePurposeToPeriod(context);
  }

  Widget changePurposeToPregnancy(BuildContext context) {
    HomeMenstruationController homeMenstruationController = Get.find<HomeMenstruationController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.changePurpose,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          child: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomExpandedCalendar(
                        firstDay: DateTime.now().subtract(Duration(days: 280)),
                        lastDay: DateTime.now(),
                        focusedDay: controller.getFocusedDate,
                        calendarFormat: CalendarFormat.month,
                        onDaySelected: (selectedDay, focusedDay) {
                          controller.setSelectedDate(selectedDay);
                          controller.setFocusedDate(focusedDay);

                          if (selectedDay != homeMenstruationController.haidAwalList.first) {
                            controller.useLastPeriodData.value = false;
                          }
                        },
                        onPageChanged: (focusedDay) {
                          controller.setFocusedDate(focusedDay);
                        },
                        selectedDayPredicate: (day) => isSameDay(
                          controller.selectedDate,
                          day,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.useLastPeriod,
                            style: CustomTextStyle.medium(15),
                            textAlign: TextAlign.center,
                          ),
                          Obx(
                            () => Switch(
                              value: controller.useLastPeriodData.value,
                              onChanged: (bool isUsingLastPeriod) {
                                if (controller.selectedDate != homeMenstruationController.haidAwalList.first) {
                                  controller.useLastPeriodData.value = isUsingLastPeriod;
                                  if (isUsingLastPeriod == true) {
                                    controller.setFocusedDate(homeMenstruationController.haidAwalList.first);
                                    controller.setSelectedDate(homeMenstruationController.haidAwalList.first);
                                  } else {
                                    controller.setFocusedDate(DateTime.now());
                                    controller.setSelectedDate(DateTime.now());
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 10.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.selectedDate,
                            style: CustomTextStyle.medium(15),
                          ),
                          Text(
                            "${formatDate(controller.selectedDate ?? DateTime.now())}",
                            style: CustomTextStyle.extraBold(15, height: 1.5),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 15,
                  child: Column(
                    children: [
                      CustomButton(
                        text: AppLocalizations.of(context)!.startPregnancy,
                        onPressed: () => controller.startPregnancy(context),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget changePurposeToPeriod(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.changePurpose,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          child: Container(
            height: Get.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.postPregnancyMenstrualCycle,
                                  style: CustomTextStyle.extraBold(22, height: 1.5),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  width: Get.width,
                                  child: Text(
                                    AppLocalizations.of(context)!.postPregnancyMenstrualCycleDesc,
                                    style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Iconsax.calendar),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.startDate,
                                    style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Obx(
                                      () => Text(
                                        "${formatDate(controller.startDate.value ?? DateTime.now())}",
                                        style: CustomTextStyle.extraBold(15, height: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.endDate,
                                    style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Obx(
                                      () => Text(
                                        "${formatDate(controller.endDate.value ?? DateTime.now())}",
                                        style: CustomTextStyle.extraBold(15, height: 1.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10.w),
                              Icon(Iconsax.calendar),
                            ],
                          ),
                        )
                      ],
                    ),
                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.range,
                        firstDate: controller.lastPregnancyHistory != null ? DateTime.parse(controller.lastPregnancyHistory?.kehamilanAkhir ?? "").add(Duration(days: 1)) : null,
                        lastDate: DateTime.now(),
                        weekdayLabels: [AppLocalizations.of(context)!.sun, AppLocalizations.of(context)!.mon, AppLocalizations.of(context)!.tue, AppLocalizations.of(context)!.wed, AppLocalizations.of(context)!.thu, AppLocalizations.of(context)!.fri, AppLocalizations.of(context)!.sat],
                        firstDayOfWeek: 1,
                        controlsHeight: 50,
                        controlsTextStyle: CustomTextStyle.bold(15),
                        centerAlignModePicker: true,
                        customModePickerIcon: const SizedBox(),
                        selectedDayHighlightColor: Color(0xFFFF6868),
                        weekdayLabelTextStyle: CustomTextStyle.regular(14),
                        dayTextStyle: CustomTextStyle.bold(16),
                        selectedDayTextStyle: CustomTextStyle.bold(16, color: Colors.white),
                        todayTextStyle: CustomTextStyle.bold(16),
                        monthTextStyle: CustomTextStyle.regular(14),
                        selectedMonthTextStyle: CustomTextStyle.bold(14, color: Colors.white),
                        disabledDayTextStyle: CustomTextStyle.regular(16, color: Colors.black.withOpacity(0.6)),
                      ),
                      value: [controller.startDate.value, controller.endDate.value],
                      onValueChanged: (dates) {
                        if (dates.first != null) {
                          controller.setStartDate(dates.first);
                          if (dates.last != null) {
                            controller.setEndDate(dates.last);
                          }
                        }
                      },
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 15,
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.addPeriod,
                    onPressed: () {
                      controller.addPeriod(context, 7, 28);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
