import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/profile_controller.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePurposeView extends GetView<ProfileController> {
  const ChangePurposeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
              controller.resetValuePregnancy();
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          child: Obx(
            () => Stack(
              children: [
                Positioned(
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TableCalendar(
                            focusedDay: controller.getFocusedDate,
                            firstDay: DateTime.now().subtract(Duration(days: 280)),
                            lastDay: DateTime.now(),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            locale: controller.storageService.getLanguage() == "en" ? 'en_US' : 'id_ID',
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
                            rowHeight: 50,
                            daysOfWeekHeight: 25.0,
                            calendarStyle: CalendarStyle(
                              cellMargin: EdgeInsets.all(6),
                              outsideDaysVisible: false,
                              isTodayHighlighted: true,
                              rangeStartDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              rangeEndDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              withinRangeDecoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              leftChevronVisible: true,
                              rightChevronVisible: true,
                              titleCentered: true,
                              titleTextStyle: CustomTextStyle.bold(16),
                              headerMargin: EdgeInsets.only(bottom: 10),
                            ),
                            availableGestures: AvailableGestures.all,
                            calendarBuilders: CalendarBuilders(
                              dowBuilder: (context, day) {
                                return Center(
                                  child: Text(
                                    DateFormat.E().format(day),
                                    style: CustomTextStyle.regular(14),
                                  ),
                                );
                              },
                              defaultBuilder: (context, day, focusedDay) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: CustomTextStyle.bold(16),
                                    ),
                                  ),
                                );
                              },
                              selectedBuilder: (context, day, focusedDay) {
                                return Container(
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: CustomTextStyle.bold(16, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                              todayBuilder: (context, day, focusedDay) {
                                return Container(
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: CustomTextStyle.bold(16, color: Colors.white),
                                    ),
                                  ),
                                );
                              },
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
                  ),
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
              controller.resetValuePregnancy();
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
          child: Obx(
            () => Container(
              width: Get.width,
              height: Get.height,
              child: Stack(
                children: [
                  Positioned(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TableCalendar(
                            focusedDay: controller.getFocusedDate,
                            firstDay: DateTime.parse(controller.currentlyPregnantData.value.hariPertamaHaidTerakhir ?? DateTime.now().toString()),
                            lastDay: DateTime.now(),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            locale: controller.storageService.getLanguage() == "en" ? 'en_US' : 'id_ID',
                            onDaySelected: (selectedDay, focusedDay) {
                              controller.setSelectedDate(selectedDay);
                              controller.setFocusedDate(focusedDay);
                            },
                            onPageChanged: (focusedDay) {
                              controller.setFocusedDate(focusedDay);
                            },
                            selectedDayPredicate: (day) => isSameDay(
                              controller.selectedDate,
                              day,
                            ),
                            rowHeight: 50,
                            daysOfWeekHeight: 25.0,
                            calendarStyle: CalendarStyle(
                              cellMargin: EdgeInsets.all(6),
                              outsideDaysVisible: false,
                              isTodayHighlighted: true,
                              rangeStartDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              rangeEndDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              withinRangeDecoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              leftChevronVisible: true,
                              rightChevronVisible: true,
                              titleCentered: true,
                              titleTextStyle: CustomTextStyle.bold(16),
                              headerMargin: EdgeInsets.only(bottom: 10),
                            ),
                            availableGestures: AvailableGestures.all,
                            calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                              return Center(
                                child: Text(
                                  DateFormat.E().format(day),
                                  style: CustomTextStyle.regular(14),
                                ),
                              );
                            }, defaultBuilder: (context, day, focusedDay) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: CustomTextStyle.bold(16),
                                  ),
                                ),
                              );
                            }, selectedBuilder: (context, day, focusedDay) {
                              return Container(
                                margin: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: CustomTextStyle.bold(16, color: Colors.white),
                                  ),
                                ),
                              );
                            }, todayBuilder: (context, day, focusedDay) {
                              return Container(
                                margin: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: CustomTextStyle.bold(16, color: Colors.white),
                                  ),
                                ),
                              );
                            }, markerBuilder: (context, day, events) {
                              for (var i = 0; i < controller.tanggalAwalMinggu.length; i++) {
                                var weekDatePregnancy = controller.tanggalAwalMinggu[i];
                                if (day.isAtSameMomentAs(weekDatePregnancy)) {
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 20.0,
                                      height: 20.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${i + 1}',
                                        style: CustomTextStyle.bold(12, color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return null;
                            }),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.selectedDate,
                                style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                              ),
                              Text(
                                "${formatDate(controller.selectedDate ?? DateTime.now())}",
                                style: CustomTextStyle.bold(15, height: 1.5),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          AppLocalizations.of(context)!.blessedWithBaby,
                          style: CustomTextStyle.extraBold(18, height: 1.5),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 70,
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Container(
                                        width: Get.width * 0.15,
                                        child: Text(
                                          AppLocalizations.of(context)!.babyGirl,
                                          style: CustomTextStyle.bold(14, height: 1.5),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: SvgPicture.asset(
                                          'assets/image/baby-girl.svg',
                                          width: 200,
                                          height: 150,
                                        ),
                                      )
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
                                  value: 'Girl',
                                  groupValue: controller.gender.value,
                                  onChanged: (String? value) {
                                    controller.gender.value = value ?? "";
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 70,
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Container(
                                        width: Get.width * 0.15,
                                        child: Text(
                                          AppLocalizations.of(context)!.babyBoy,
                                          style: CustomTextStyle.bold(14, height: 1.5),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: SvgPicture.asset(
                                          'assets/image/baby-boy.svg',
                                          width: 200,
                                          height: 150,
                                        ),
                                      )
                                    ],
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
                                  value: 'Boy',
                                  groupValue: controller.gender.value,
                                  onChanged: (String? value) {
                                    controller.gender.value = value ?? "";
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 15,
                    child: Column(
                      children: [
                        CustomButton(
                          text: AppLocalizations.of(context)!.deletePregnancy,
                          textColor: AppColors.black,
                          backgroundColor: AppColors.transparent,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Text(
                                    AppLocalizations.of(context)!.deletePregnancyConfirm,
                                    style: CustomTextStyle.bold(22),
                                  ),
                                  contentPadding: EdgeInsets.all(16.0),
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              shadowColor: Colors.transparent,
                                              minimumSize: Size(Get.width, 45.h),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!.no,
                                              style: CustomTextStyle.bold(16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.deletePregnancy(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              shadowColor: AppColors.primary,
                                              minimumSize: Size(Get.width, 45.h),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!.yes,
                                              style: CustomTextStyle.bold(16, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 5.h),
                        Obx(
                          () => CustomButton(
                            text: AppLocalizations.of(context)!.endPregnancy,
                            onPressed: () {
                              (controller.gender.value == "") ? null : controller.endPregnancy(context);
                            },
                            backgroundColor: (controller.gender.value == "") ? Colors.grey : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
