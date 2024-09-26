import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_expanded_calendar.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_filter_chip.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/logs_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/notes_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/temperature_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/pregnancy_log_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PregnancyLogView extends GetView<PregnancyLogController> {
  const PregnancyLogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PregnancyLogController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.pregnancyLog,
                    style: CustomTextStyle.extraBold(20),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.h),
                        height: Get.height * 0.97,
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.pregnancyDailyLog,
                                    style: CustomTextStyle.extraBold(22, height: 1.5),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    AppLocalizations.of(context)!.pregnancyDailyLogDesc,
                                    style: CustomTextStyle.medium(16, height: 1.75),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.help,
                  size: 20,
                  color: AppColors.black.withOpacity(0.4),
                ),
              ),
            ],
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
        actions: [
          TextButton(
            onPressed: () {
              controller.deletePregnancyLog(context, controller.selectedDate);
            },
            child: Text(
              AppLocalizations.of(context)!.reset,
              style: CustomTextStyle.extraBold(15, color: AppColors.primary),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'pregnancy_symptoms':
                  Get.to(() => LogsView(), arguments: "pregnancy_symptoms");
                  break;
                case 'pregnancy_notes':
                  Get.to(() => NotesView(), arguments: "pregnancy_notes");
                  break;
                case 'pregnancy_temperature':
                  Get.to(() => TemperatureView(), arguments: "pregnancy_temperature");
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'pregnancy_symptoms',
                child: Row(
                  children: [
                    Icon(Icons.history, color: Colors.black),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.logs),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'pregnancy_notes',
                child: Row(
                  children: [
                    Icon(Icons.notes, color: Colors.black),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.notes),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'pregnancy_temperature',
                child: Row(
                  children: [
                    Icon(Icons.thermostat, color: Colors.black),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.temperature),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setSelectedDate(DateTime.now());
          controller.setFocusedDate(DateTime.now());
          controller.fetchPregnancyLog(DateTime.now());
        },
        child: Icon(Icons.today_outlined),
        tooltip: AppLocalizations.of(context)!.backToCurrentDate,
      ),
      body: FutureBuilder(
        future: controller.fetchPregnancyData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Obx(
              () => Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
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
                                controller.fetchPregnancyLog(selectedDay);
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
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              width: Get.width,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      child: Text(
                                        AppLocalizations.of(context)!.pregnancySymptoms,
                                        style: CustomTextStyle.bold(20, height: 1.5),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Obx(
                                      () => Container(
                                        width: Get.width,
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 8.0,
                                          children: controller.pregnancySymptoms.map(
                                            (symptoms) {
                                              final symptomsTranslations = controller.pregnancySymptomsTranslate(context);
                                              return CustomFilterChip(
                                                label: symptomsTranslations[symptoms] ?? symptoms,
                                                isSelected: controller.getSelectedPregnancySymptoms().contains(symptoms),
                                                onSelected: (bool isSelected) {
                                                  List<String> selectedSymptoms = List.from(controller.getSelectedPregnancySymptoms());

                                                  if (selectedSymptoms.contains(symptoms)) {
                                                    selectedSymptoms.remove(symptoms);
                                                  } else {
                                                    selectedSymptoms.add(symptoms);
                                                  }

                                                  controller.setSelectedPregnancySymptoms(selectedSymptoms);
                                                  controller.update();
                                                },
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PopScope(
                                      onPopInvoked: (didPop) {
                                        if (didPop) {
                                          controller.resetTemperature();
                                        }
                                      },
                                      child: Wrap(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 20.h),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Iconsax.weight,
                                                    size: 35,
                                                    color: Color(0xFFFF6868),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    AppLocalizations.of(context)!.basalTemperature,
                                                    style: CustomTextStyle.bold(20, height: 1.5),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Obx(
                                                        () => NumberPicker(
                                                          minValue: 35,
                                                          maxValue: 42,
                                                          value: controller.selectedTemperatureWholeNumber ?? 36,
                                                          onChanged: controller.setTemperatureWholeNumber,
                                                          textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                          selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
                                                          infiniteLoop: true,
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(color: Colors.black),
                                                              bottom: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        ".",
                                                        style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                      ),
                                                      Obx(
                                                        () => NumberPicker(
                                                          minValue: 0,
                                                          maxValue: 9,
                                                          value: controller.selectedTemperatureDecimalNumber ?? 0,
                                                          onChanged: controller.setTemperatureDecimalNumber,
                                                          textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                          selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
                                                          infiniteLoop: true,
                                                          decoration: BoxDecoration(
                                                            border: Border(
                                                              top: BorderSide(color: Colors.black),
                                                              bottom: BorderSide(color: Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        " °C",
                                                        style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 30.h),
                                                  CustomButton(
                                                    text: AppLocalizations.of(context)!.saveTemperature,
                                                    onPressed: () {
                                                      controller.updateTemperature();
                                                      Navigator.pop(context, true);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Wrap(
                                children: [
                                  Container(
                                    width: Get.width,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Iconsax.wind),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Obx(() {
                                                  return controller.temperature != 0.0
                                                      ? Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.temperature,
                                                              style: CustomTextStyle.bold(20, height: 1.75),
                                                            ),
                                                            Text.rich(
                                                              TextSpan(
                                                                text: "${controller.getTemperature()}",
                                                                style: CustomTextStyle.extraBold(24, height: 1.5, color: Color(0xFFFD6666)),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: ' °C',
                                                                    style: CustomTextStyle.medium(16, height: 1.5, color: Color(0xFFFD6666)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Text(
                                                          AppLocalizations.of(context)!.temperature,
                                                          style: CustomTextStyle.bold(18, height: 1.5),
                                                        );
                                                }),
                                              ],
                                            ),
                                          ),
                                          Icon(Iconsax.arrow_right_34)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Wrap(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 20.h),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Iconsax.edit_24,
                                                size: 35,
                                                color: Color(0xFFFF6868),
                                              ),
                                              SizedBox(height: 10.h),
                                              Text(
                                                AppLocalizations.of(context)!.dailyNotes,
                                                style: CustomTextStyle.bold(20, height: 1.5),
                                              ),
                                              SizedBox(height: 20.h),
                                              TextFormField(
                                                minLines: 7,
                                                maxLines: 7,
                                                style: CustomTextStyle.medium(15, height: 1.5),
                                                onChanged: controller.updateNotes,
                                                initialValue: controller.getNotes(),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 25.h),
                                              CustomButton(
                                                text: AppLocalizations.of(context)!.saveNotes,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Wrap(
                                children: [
                                  Container(
                                    width: Get.width,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Iconsax.edit_24),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.dailyNotes,
                                                  style: CustomTextStyle.bold(18, height: 1.75),
                                                ),
                                                Obx(
                                                  () => controller.notes.value.isNotEmpty
                                                      ? Text(
                                                          "${controller.notes.value}",
                                                          style: CustomTextStyle.semiBold(14, color: Color(0xFFFD6666)),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        )
                                                      : SizedBox.shrink(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(Iconsax.arrow_right_34)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () => Container(
                              height: controller.isChanged.value ? 90.h : 8.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Obx(
                      () => Visibility(
                        visible: controller.isChanged.value,
                        child: Container(
                          height: 80.h,
                          color: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          child: CustomButton(
                            text: AppLocalizations.of(context)!.addDailyLog,
                            onPressed: () {
                              controller.savePregnancyLog(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
