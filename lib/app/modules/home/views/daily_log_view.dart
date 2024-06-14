import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
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
    final ApiService apiService = ApiService();
    Get.put(DailyLogController());
    return Scaffold(
      backgroundColor: Color(0xFFf9f8fb),
      appBar: AppBar(
        backgroundColor: Color(0xFFf9f8fb),
        surfaceTintColor: Color(0xFFf9f8fb),
        leading: const BackButton(
          color: Color(0xFFFD6666),
        ),
        title: Text(
          'Daily Log',
          style: TextStyle(
            fontFamily: "Popins",
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              controller.resetLog();
            },
            child: Text(
              'Reset',
              style: TextStyle(
                color: Color(0xFFFD6666),
                fontFamily: "Popins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.setFocusedDate(DateTime.now());
          controller.setSelectedDate(DateTime.now());
        },
        child: Icon(Icons.today_outlined),
        tooltip: "Back to current date",
      ),
      body: FutureBuilder<PeriodCycle?>(
        future: PeriodRepository(apiService).getPeriodSummary(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError) {
            //   return Text("Error: ${snapshot.error}");
            // } else if (!snapshot.hasData || snapshot.data == null) {
            //   return Text("No data available");
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
                                color: Color.fromARGB(255, 246, 245, 245),
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
                                  controller
                                      .fetchLog(selectedDay.toIso8601String());
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: AppColors.contrast,
                                  ),
                                  formatButtonVisible: false,
                                  leftChevronVisible: true,
                                  rightChevronVisible: true,
                                  titleCentered: true,
                                  formatButtonShowsNext: false,
                                  formatButtonTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  formatButtonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    color: Colors.red,
                                  ),
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  headerMargin: EdgeInsets.only(bottom: 10),
                                ),
                                availableGestures: AvailableGestures.all,
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    for (int i = 0;
                                        i < homeController.haidAwalList.length;
                                        i++) {
                                      if (day.isAtSameMomentAs(
                                              homeController.haidAwalList[i]) ||
                                          day.isAfter(homeController
                                                  .haidAwalList[i]) &&
                                              day.isBefore(homeController
                                                  .haidAkhirList[i]) ||
                                          day.isAtSameMomentAs(
                                              homeController.haidAkhirList[i]))
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                    }

                                    for (int j = 0;
                                        j < homeController.ovulasiList.length;
                                        j++) {
                                      if (day.isAtSameMomentAs(
                                          homeController.ovulasiList[j])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i <
                                            homeController
                                                .masaSuburAwalList.length;
                                        i++) {
                                      if (day.isAtSameMomentAs(homeController
                                              .masaSuburAwalList[i]) ||
                                          day.isAfter(homeController
                                                  .masaSuburAwalList[i]) &&
                                              day.isBefore(homeController
                                                  .masaSuburAkhirList[i]) ||
                                          day.isAtSameMomentAs(homeController
                                              .masaSuburAkhirList[i])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i <
                                            homeController
                                                .predictHaidAwalList.length;
                                        i++) {
                                      if ((day.isAtSameMomentAs(homeController
                                              .predictHaidAwalList[i]) ||
                                          day.isAfter(homeController
                                                  .predictHaidAwalList[i]) &&
                                              day.isBefore(homeController
                                                  .predictHaidAkhirList[i]) ||
                                          day.isAtSameMomentAs(homeController
                                              .predictHaidAkhirList[i]))) {
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
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int j = 0;
                                        j <
                                            homeController
                                                .predictOvulasiList.length;
                                        j++) {
                                      if (day.isAtSameMomentAs(homeController
                                          .predictOvulasiList[j])) {
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
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i <
                                            homeController
                                                .predictMasaSuburAwalList
                                                .length;
                                        i++) {
                                      if ((day.isAtSameMomentAs(homeController
                                              .predictMasaSuburAwalList[i]) ||
                                          day.isAfter(homeController
                                                      .predictMasaSuburAwalList[
                                                  i]) &&
                                              day.isBefore(homeController
                                                      .predictMasaSuburAkhirList[
                                                  i]) ||
                                          day.isAtSameMomentAs(homeController
                                              .predictMasaSuburAkhirList[i]))) {
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
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  dowBuilder: (context, day) {
                                    return Center(
                                      child: Text(
                                        DateFormat.E().format(day),
                                        style: TextStyle(
                                          color: Colors.black,
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
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
                                                  (activity) =>
                                                      CustomChoiceChip(
                                                    label: activity,
                                                    isSelected: controller
                                                            .getSelectedSexActivity() ==
                                                        activity,
                                                    onSelected: () {
                                                      if (controller
                                                              .getSelectedSexActivity() ==
                                                          activity) {
                                                        controller
                                                            .setSelectedSexActivity(
                                                                "");
                                                      } else {
                                                        controller
                                                            .setSelectedSexActivity(
                                                                activity);
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
                                  visible: homeController.checkDateMenstruation(
                                      controller.selectedDate),
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
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Obx(
                                            () => Container(
                                              width: Get.width,
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                spacing: 8.0,
                                                children:
                                                    controller.bleedingFlow
                                                        .map(
                                                          (bleedingFlow) =>
                                                              CustomChoiceChip(
                                                            label: bleedingFlow,
                                                            isSelected: controller
                                                                    .getSelectedBleedingFlow() ==
                                                                bleedingFlow,
                                                            onSelected: () {
                                                              if (controller
                                                                      .getSelectedBleedingFlow() ==
                                                                  bleedingFlow) {
                                                                controller
                                                                    .setSelectedBleedingFlow(
                                                                        "");
                                                              } else {
                                                                controller
                                                                    .setSelectedBleedingFlow(
                                                                        bleedingFlow);
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
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
                                                  (symptoms) =>
                                                      CustomFilterChip(
                                                    label: symptoms,
                                                    isSelected: controller
                                                        .getSelectedSymptoms()
                                                        .contains(symptoms),
                                                    onSelected:
                                                        (bool isSelected) {
                                                      List<String>
                                                          selectedSymptoms =
                                                          List.from(controller
                                                              .getSelectedSymptoms());

                                                      if (selectedSymptoms
                                                          .contains(symptoms)) {
                                                        selectedSymptoms
                                                            .remove(symptoms);
                                                      } else {
                                                        selectedSymptoms
                                                            .add(symptoms);
                                                      }

                                                      controller
                                                          .setSelectedSymptoms(
                                                              selectedSymptoms);
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Obx(
                                        () => Container(
                                          width: Get.width,
                                          child: Wrap(
                                            alignment: WrapAlignment.start,
                                            spacing: 8.0,
                                            children:
                                                controller.vaginalDischarge
                                                    .map(
                                                      (vaginalDischarge) =>
                                                          CustomChoiceChip(
                                                        label: vaginalDischarge,
                                                        isSelected: controller
                                                                .getSelectedVaginalDischarge() ==
                                                            vaginalDischarge,
                                                        onSelected: () {
                                                          if (controller
                                                                  .getSelectedVaginalDischarge() ==
                                                              vaginalDischarge) {
                                                            controller
                                                                .setSelectedVaginalDischarge(
                                                                    "");
                                                          } else {
                                                            controller
                                                                .setSelectedVaginalDischarge(
                                                                    vaginalDischarge);
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
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
                                                    isSelected: controller
                                                        .getSelectedMoods()
                                                        .contains(moods),
                                                    onSelected:
                                                        (bool isSelected) {
                                                      List<String>
                                                          selectedMoods =
                                                          List.from(controller
                                                              .getSelectedMoods());

                                                      if (selectedMoods
                                                          .contains(moods)) {
                                                        selectedMoods
                                                            .remove(moods);
                                                      } else {
                                                        selectedMoods
                                                            .add(moods);
                                                      }

                                                      controller
                                                          .setSelectedMoods(
                                                              selectedMoods);
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
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
                                                    isSelected: controller
                                                        .getSelectedOthers()
                                                        .contains(others),
                                                    onSelected:
                                                        (bool isSelected) {
                                                      List<String>
                                                          selectedOthers =
                                                          List.from(controller
                                                              .getSelectedOthers());

                                                      if (selectedOthers
                                                          .contains(others)) {
                                                        selectedOthers
                                                            .remove(others);
                                                      } else {
                                                        selectedOthers
                                                            .add(others);
                                                      }

                                                      controller
                                                          .setSelectedOthers(
                                                              selectedOthers);
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Obx(
                                        () => Container(
                                          width: Get.width,
                                          child: Wrap(
                                            alignment: WrapAlignment.start,
                                            spacing: 8.0,
                                            children:
                                                controller.physicalActivity
                                                    .map(
                                                      (physicalActivity) =>
                                                          CustomFilterChip(
                                                        label: physicalActivity,
                                                        isSelected: controller
                                                            .getSelectedPhysicalActivity()
                                                            .contains(
                                                                physicalActivity),
                                                        onSelected:
                                                            (bool isSelected) {
                                                          List<String>
                                                              selectedPhysicalActivity =
                                                              List.from(controller
                                                                  .getSelectedPhysicalActivity());

                                                          if (selectedPhysicalActivity
                                                              .contains(
                                                                  physicalActivity)) {
                                                            selectedPhysicalActivity
                                                                .remove(
                                                                    physicalActivity);
                                                          } else {
                                                            selectedPhysicalActivity
                                                                .add(
                                                                    physicalActivity);
                                                          }

                                                          controller
                                                              .setSelectedPhysicalActivity(
                                                                  selectedPhysicalActivity);
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
                                      return SizedBox(
                                        height: 400,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 35.h),
                                                Icon(
                                                  Iconsax.weight,
                                                  size: 35,
                                                  color: Color(0xFFFF6868),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  "Basal Temperature",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    letterSpacing: 0.8,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Obx(
                                                      () => NumberPicker(
                                                        minValue: 32,
                                                        maxValue: 43,
                                                        value: controller
                                                            .wholeNumberTemperature
                                                            .value,
                                                        onChanged: controller
                                                            .onWholeNumberTemperatureChanged,
                                                        textStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20.sp),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xFFFF6868),
                                                          fontSize: 23.sp,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        infiniteLoop: true,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ".",
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => NumberPicker(
                                                        minValue: 0,
                                                        maxValue: 9,
                                                        value: controller
                                                            .decimalNumberTemperature
                                                            .value,
                                                        onChanged: controller
                                                            .onDecimalNumberTemperatureChanged,
                                                        textStyle: TextStyle(
                                                            color: Colors.grey),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xFFFF6868),
                                                          fontSize: 20.sp,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        infiniteLoop: true,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      " °C",
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFFF6868),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30.h),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFFD6666),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      minimumSize: Size(
                                                          Get.width, 45.h)),
                                                  child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.38,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Iconsax.wind),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    final temperatureValue =
                                                        controller
                                                            .temperature.value;
                                                    return temperatureValue
                                                            .isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Temperature",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  height: 2.0,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text:
                                                                      "$temperatureValue",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        24.sp,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFFFD6666),
                                                                  ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          ' °C',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Color(
                                                                            0xFFFD6666),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            "Temperature",
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              height: 2.0,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                            ),
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
                                      return SizedBox(
                                        height: 400,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                SizedBox(height: 35.h),
                                                Icon(
                                                  Iconsax.weight,
                                                  size: 35,
                                                  color: Color(0xFFFF6868),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  "My Weight",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    letterSpacing: 0.8,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Obx(
                                                      () => NumberPicker(
                                                        minValue: 30,
                                                        maxValue: 150,
                                                        value: controller
                                                            .wholeNumberWeight
                                                            .value,
                                                        onChanged: controller
                                                            .onWholeNumberWeightChanged,
                                                        textStyle: TextStyle(
                                                            color: Colors.grey),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xFFFF6868),
                                                          fontSize: 23.sp,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        infiniteLoop: true,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ".",
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Obx(
                                                      () => NumberPicker(
                                                        minValue: 0,
                                                        maxValue: 9,
                                                        value: controller
                                                            .decimalNumberWeight
                                                            .value,
                                                        onChanged: controller
                                                            .onDecimalNumberWeightChanged,
                                                        textStyle: TextStyle(
                                                            color: Colors.grey),
                                                        selectedTextStyle:
                                                            TextStyle(
                                                          color:
                                                              Color(0xFFFF6868),
                                                          fontSize: 23.sp,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        infiniteLoop: true,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      " Kg",
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFFF6868),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 30.h),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFFD6666),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      minimumSize: Size(
                                                          Get.width, 45.h)),
                                                  child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.38,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Iconsax.weight),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    final weightValue =
                                                        controller
                                                            .weights.value;
                                                    return weightValue
                                                            .isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Weight",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  height: 2.0,
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text:
                                                                      "$weightValue",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        24.sp,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFFFD6666),
                                                                  ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          ' Kg',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Color(
                                                                            0xFFFD6666),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            "Weight",
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              height: 2.0,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                            ),
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
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: SizedBox(
                                          height: 430,
                                          child: Padding(
                                            padding: const EdgeInsets.all(25),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 25.h),
                                                  Icon(
                                                    Iconsax.edit_24,
                                                    size: 35,
                                                    color: Color(0xFFFF6868),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    "Daily Notes",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      letterSpacing: 0.8,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 15.h),
                                                  TextFormField(
                                                    minLines: 7,
                                                    maxLines: 7,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    onChanged:
                                                        controller.updateNotes,
                                                    initialValue:
                                                        controller.getNotes(),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 30.h),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFFFD6666),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      minimumSize:
                                                          Size(Get.width, 45.h),
                                                    ),
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.38,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Iconsax.edit_24),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Daily Notes",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      height: 2.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Obx(
                                                    () => controller.notes.value
                                                            .isNotEmpty
                                                        ? Text(
                                                            "${controller.notes.value}",
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFFFD6666),
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                  height:
                                      controller.isChanged.value ? 75.h : 8.h,
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
                        child: CustomColoredButton(
                          text: "add",
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
