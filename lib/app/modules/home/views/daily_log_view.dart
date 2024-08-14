import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_choice_chip.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_filter_chip.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/daily_log_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyLogView extends GetView<DailyLogController> {
  final HomeMenstruationController homeController;
  DailyLogView({Key? key})
      : homeController = Get.find<HomeMenstruationController>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DailyLogController());
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color(0xFFFD6666),
        ),
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Obx(
            () => Text(
              "Log on ${DateFormat('dd, MMMM yyy').format(controller.selectedDate)}",
              style: CustomTextStyle.extraBold(20),
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 4,
        actions: [
          TextButton(
            onPressed: () {
              controller.resetLog();
              controller.saveLog();
            },
            child: Text(
              'Reset',
              style: CustomTextStyle.extraBold(15, color: AppColors.primary),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setSelectedDate(DateTime.now());
          controller.setFocusedDate(DateTime.now());
          controller.fetchLog(DateTime.now());
        },
        child: Icon(Icons.today_outlined),
        tooltip: "Back to current date",
      ),
      body: FutureBuilder<DataHarian?>(
        future: controller.futureDataHarian,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TableCalendar(
                                focusedDay: controller.getFocusedDate,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.now(),
                                calendarFormat: CalendarFormat.week,
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                onDaySelected: (selectedDay, focusedDay) {
                                  controller.setSelectedDate(selectedDay);
                                  controller.setFocusedDate(focusedDay);
                                  controller.fetchLog(selectedDay);
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
                                  defaultBuilder: (context, day, focusedDay) {
                                    for (int i = 0; i < homeController.haidAwalList.length; i++) {
                                      if (day.isAtSameMomentAs(homeController.haidAwalList[i]) || day.isAfter(homeController.haidAwalList[i]) && day.isBefore(homeController.haidAkhirList[i]) || day.isAtSameMomentAs(homeController.haidAkhirList[i]))
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: CustomTextStyle.bold(16, color: Colors.white),
                                            ),
                                          ),
                                        );
                                    }

                                    for (int j = 0; j < homeController.ovulasiList.length; j++) {
                                      if (day.isAtSameMomentAs(homeController.ovulasiList[j])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: CustomTextStyle.bold(16, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0; i < homeController.masaSuburAwalList.length; i++) {
                                      if (day.isAtSameMomentAs(homeController.masaSuburAwalList[i]) || day.isAfter(homeController.masaSuburAwalList[i]) && day.isBefore(homeController.masaSuburAkhirList[i]) || day.isAtSameMomentAs(homeController.masaSuburAkhirList[i])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: CustomTextStyle.bold(16, color: Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0; i < homeController.predictHaidAwalList.length; i++) {
                                      if ((day.isAtSameMomentAs(homeController.predictHaidAwalList[i]) || day.isAfter(homeController.predictHaidAwalList[i]) && day.isBefore(homeController.predictHaidAkhirList[i]) || day.isAtSameMomentAs(homeController.predictHaidAkhirList[i]))) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.pink,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: CustomTextStyle.bold(16),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int j = 0; j < homeController.predictOvulasiList.length; j++) {
                                      if (day.isAtSameMomentAs(homeController.predictOvulasiList[j])) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.blue,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: CustomTextStyle.bold(16),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0; i < homeController.predictMasaSuburAwalList.length; i++) {
                                      if ((day.isAtSameMomentAs(homeController.predictMasaSuburAwalList[i]) || day.isAfter(homeController.predictMasaSuburAwalList[i]) && day.isBefore(homeController.predictMasaSuburAkhirList[i]) || day.isAtSameMomentAs(homeController.predictMasaSuburAkhirList[i]))) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.green,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: CustomTextStyle.bold(16),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    return Container(
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: CustomTextStyle.bold(16),
                                        ),
                                      ),
                                    );
                                  },
                                  dowBuilder: (context, day) {
                                    return Center(
                                      child: Text(
                                        DateFormat.E().format(day),
                                        style: CustomTextStyle.regular(14),
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
                          ),
                          SizedBox(height: 16.h),
                          Wrap(
                            runSpacing: 16,
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
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
                                          "Sex Activity",
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
                                            children: controller.sexActivity
                                                .map(
                                                  (activity) => CustomChoiceChip(
                                                    label: activity,
                                                    isSelected: controller.getSelectedSexActivity() == activity,
                                                    onSelected: () {
                                                      if (controller.getSelectedSexActivity() == activity) {
                                                        controller.setSelectedSexActivity("");
                                                      } else {
                                                        controller.setSelectedSexActivity(activity);
                                                      }
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                  visible: homeController.checkDateMenstruation(controller.selectedDate),
                                  child: Container(
                                    alignment: Alignment.topCenter,
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
                                              "Bleeding Flow",
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
                                                children: controller.bleedingFlow
                                                    .map(
                                                      (bleedingFlow) => CustomChoiceChip(
                                                        label: bleedingFlow,
                                                        isSelected: controller.getSelectedBleedingFlow() == bleedingFlow,
                                                        onSelected: () {
                                                          if (controller.getSelectedBleedingFlow() == bleedingFlow) {
                                                            controller.setSelectedBleedingFlow("");
                                                          } else {
                                                            controller.setSelectedBleedingFlow(bleedingFlow);
                                                          }
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                                  child: Column(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        child: Text(
                                          "Symptoms",
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
                                            children: controller.symptoms
                                                .map(
                                                  (symptoms) => CustomFilterChip(
                                                    label: symptoms,
                                                    isSelected: controller.getSelectedSymptoms().contains(symptoms),
                                                    onSelected: (bool isSelected) {
                                                      List<String> selectedSymptoms = List.from(controller.getSelectedSymptoms());

                                                      if (selectedSymptoms.contains(symptoms)) {
                                                        selectedSymptoms.remove(symptoms);
                                                      } else {
                                                        selectedSymptoms.add(symptoms);
                                                      }

                                                      controller.setSelectedSymptoms(selectedSymptoms);
                                                      controller.update();
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topCenter,
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
                                          "Vaginal Discharge",
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
                                            children: controller.vaginalDischarge
                                                .map(
                                                  (vaginalDischarge) => CustomChoiceChip(
                                                    label: vaginalDischarge,
                                                    isSelected: controller.getSelectedVaginalDischarge() == vaginalDischarge,
                                                    onSelected: () {
                                                      if (controller.getSelectedVaginalDischarge() == vaginalDischarge) {
                                                        controller.setSelectedVaginalDischarge("");
                                                      } else {
                                                        controller.setSelectedVaginalDischarge(vaginalDischarge);
                                                      }
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                  child: Column(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        child: Text(
                                          "Moods",
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
                                            children: controller.moods
                                                .map(
                                                  (moods) => CustomFilterChip(
                                                    label: moods,
                                                    isSelected: controller.getSelectedMoods().contains(moods),
                                                    onSelected: (bool isSelected) {
                                                      List<String> selectedMoods = List.from(controller.getSelectedMoods());

                                                      if (selectedMoods.contains(moods)) {
                                                        selectedMoods.remove(moods);
                                                      } else {
                                                        selectedMoods.add(moods);
                                                      }

                                                      controller.setSelectedMoods(selectedMoods);
                                                      controller.update();
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                  child: Column(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        child: Text(
                                          "Others",
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
                                            children: controller.others
                                                .map(
                                                  (others) => CustomFilterChip(
                                                    label: others,
                                                    isSelected: controller.getSelectedOthers().contains(others),
                                                    onSelected: (bool isSelected) {
                                                      List<String> selectedOthers = List.from(controller.getSelectedOthers());

                                                      if (selectedOthers.contains(others)) {
                                                        selectedOthers.remove(others);
                                                      } else {
                                                        selectedOthers.add(others);
                                                      }

                                                      controller.setSelectedOthers(selectedOthers);
                                                      controller.update();
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                  child: Column(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        child: Text(
                                          "Physical Activity",
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
                                            children: controller.physicalActivity
                                                .map(
                                                  (physicalActivity) => CustomFilterChip(
                                                    label: physicalActivity,
                                                    isSelected: controller.getSelectedPhysicalActivity().contains(physicalActivity),
                                                    onSelected: (bool isSelected) {
                                                      List<String> selectedPhysicalActivity = List.from(controller.getSelectedPhysicalActivity());

                                                      if (selectedPhysicalActivity.contains(physicalActivity)) {
                                                        selectedPhysicalActivity.remove(physicalActivity);
                                                      } else {
                                                        selectedPhysicalActivity.add(physicalActivity);
                                                      }

                                                      controller.setSelectedPhysicalActivity(selectedPhysicalActivity);
                                                      controller.update();
                                                    },
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
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
                                                      "Basal Temperature",
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
                                                      text: "Save Temperature",
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
                                                                "Temperature",
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
                                                            "Temperature",
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
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PopScope(
                                        onPopInvoked: (didPop) {
                                          if (didPop) {
                                            controller.resetWeight();
                                          }
                                        },
                                        child: Wrap(
                                          children: [
                                            Container(
                                              child: Padding(
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
                                                        "My Weight",
                                                        style: CustomTextStyle.bold(20, height: 1.5),
                                                      ),
                                                      SizedBox(height: 10.h),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Obx(
                                                            () => NumberPicker(
                                                              minValue: 30,
                                                              maxValue: 150,
                                                              value: controller.selectedWeightWholeNumber ?? 70,
                                                              onChanged: controller.setWeightWholeNumber,
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
                                                              value: controller.selectedWeightDecimalNumber ?? 0,
                                                              onChanged: controller.setWeightDecimalNumber,
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
                                                            " Kg",
                                                            style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 30.h),
                                                      CustomButton(
                                                        text: "Save Weight",
                                                        onPressed: () {
                                                          controller.updateWeight();
                                                          Navigator.pop(context, true);
                                                        },
                                                      ),
                                                    ],
                                                  ),
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
                                            Icon(Iconsax.weight),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return controller.getWeight() != 0.0
                                                        ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Weight",
                                                                style: CustomTextStyle.bold(20, height: 1.75),
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: "${controller.getWeight()}",
                                                                  style: CustomTextStyle.extraBold(24, height: 1.5, color: Color(0xFFFD6666)),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: ' Kg',
                                                                      style: CustomTextStyle.medium(16, height: 1.5, color: Color(0xFFFD6666)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            "Weight",
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
                              GestureDetector(
                                onTap: () {
                                  controller.originalWeight.value = controller.weights.value;
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
                                                  "Daily Notes",
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
                                                  text: "Save notes",
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
                                                    "Daily Notes",
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
                              Obx(
                                () => Container(
                                  height: controller.isChanged.value ? 75.h : 8.h,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          text: "Add Daily Log",
                          onPressed: () {
                            controller.saveLog();
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
