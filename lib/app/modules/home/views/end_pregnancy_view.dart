import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_expanded_calendar.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/end_pregnancy_controller.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndPregnancyView extends GetView<EndPregnancyController> {
  const EndPregnancyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(EndPregnancyController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.reportBirth,
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
      body: SafeArea(
        child: FutureBuilder(
          future: controller.fetchPregnancyData(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                child: Obx(
                  () => Container(
                    width: Get.width,
                    height: Get.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomExpandedCalendar(
                              firstDay: DateTime.parse(controller.currentlyPregnantData.value.hariPertamaHaidTerakhir ?? DateTime.now().toString()),
                              lastDay: DateTime.now(),
                              focusedDay: controller.getFocusedDate,
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
                              calendarFormat: CalendarFormat.month,
                              markerBuilder: (context, day, events) {
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
                                return SizedBox();
                              },
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
                          SizedBox(height: 30),
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
                                      textAlign: TextAlign.center,
                                    ),
                                    contentPadding: EdgeInsets.all(16.0),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.deletePregnancyConfirmDesc,
                                          style: CustomTextStyle.medium(15, height: 1.5),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 10),
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
                                                AppLocalizations.of(context)!.cancel,
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
                                                AppLocalizations.of(context)!.delete,
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
                              onPressed: controller.weekPregnancyEnded() > 24
                                  ? controller.gender.value.isNotEmpty
                                      ? () {
                                          controller.endPregnancy(context);
                                        }
                                      : () {}
                                  : () {},
                              backgroundColor: controller.weekPregnancyEnded() > 24
                                  ? controller.gender.value.isEmpty
                                      ? AppColors.primary
                                      : Colors.grey
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
