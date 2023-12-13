import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_controller.dart';

class DailyLogView extends GetView<HomeController> {
  const DailyLogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf9f8fb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Calendar(
                  startOnMonday: true,
                  weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  eventsList: controller.getMenstruationCycle(),
                  eventDoneColor: Colors.green,
                  selectedColor: Colors.pink,
                  selectedTodayColor: Colors.amber,
                  todayColor: Colors.blue,
                  locale: 'en_US',
                  todayButtonText: 'Today',
                  hideTodayIcon: true,
                  allDayEventText: 'All Day',
                  multiDayEndText: 'End',
                  defaultDayColor: Colors.black,
                  isExpanded: false,
                  datePickerType: DatePickerType.hidden,
                  dayOfWeekStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                  showEvents: false,
                  onDateSelected: (DateTime selectedDate) {
                    controller.setSelectedDate(selectedDate);
                  },
                  dayBuilder: (BuildContext context, DateTime day) {
                    bool isSelectedDay =
                        controller.selectedDate?.day == day.day &&
                            controller.selectedDate?.month == day.month &&
                            controller.selectedDate?.year == day.year;

                    bool isSpecialDate1 = day.isAfter(DateTime(2023, 10, 1)) &&
                        day.isBefore(DateTime(2023, 10, 11));

                    bool isSpecialDate2 = day.isAfter(DateTime(2023, 11, 1)) &&
                        day.isBefore(DateTime(2023, 11, 11));

                    bool isInCurrentMonth =
                        day.month == controller.selectedDate?.month;

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelectedDay
                            ? Colors.pink
                            : isSpecialDate1
                                ? Colors.blue
                                : isSpecialDate2
                                    ? Colors.green
                                    : Colors.transparent,
                        border: Border.all(
                          color:
                              isSelectedDay ? Colors.pink : Colors.transparent,
                          width: 3.0,
                          style: isSelectedDay
                              ? BorderStyle.solid
                              : BorderStyle.none,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isSelectedDay
                                ? Colors.white
                                : isInCurrentMonth
                                    ? Colors.black
                                    : Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Wrap(
                  runSpacing: 16,
                  children: [
                    Container(
                      width: Get.width,
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.10000000149011612),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              width: Get.width,
                              child: Text(
                                "Pregnancy signs",
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
                                  children: controller.pregnancySigns
                                      .map(
                                        (sign) => FilterChip(
                                          label: Text(sign),
                                          // showCheckmark: false,
                                          selected: controller
                                              .getSelectedPregnancySigns()
                                              .contains(sign),
                                          onSelected: (bool isSelected) {
                                            List<String> selectedSigns =
                                                List.from(controller
                                                    .getSelectedPregnancySigns());

                                            if (isSelected) {
                                              if (!selectedSigns
                                                  .contains(sign)) {
                                                selectedSigns.add(sign);
                                              }
                                            } else {
                                              if (selectedSigns
                                                  .contains(sign)) {
                                                selectedSigns.remove(sign);
                                              }
                                            }

                                            controller
                                                .setSelectedPregnancySigns(
                                                    selectedSigns);
                                            controller.update();
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                    .getSelectedPregnancySigns()
                                                    .contains(sign)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
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
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                  children: controller.sex_activity
                                      .map(
                                        (activity) => ChoiceChip(
                                          label: Text(activity),
                                          selected: controller
                                                  .getSelectedSexActivity() ==
                                              activity,
                                          onSelected: (bool isSelected) {
                                            if (isSelected) {
                                              controller.setSelectedSexActivity(
                                                  activity);
                                            } else {
                                              controller
                                                  .setSelectedSexActivity("");
                                            }
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                        .getSelectedSexActivity() ==
                                                    activity
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
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
                        color: Colors.white.withOpacity(0.10000000149011612),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 3,
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                        (symptoms) => FilterChip(
                                          label: Text(symptoms),
                                          selected: controller
                                              .getSelectedSymptoms()
                                              .contains(symptoms),
                                          onSelected: (bool isSelected) {
                                            List<String> selectedSymptoms =
                                                List.from(controller
                                                    .getSelectedSymptoms());

                                            if (isSelected) {
                                              if (!selectedSymptoms
                                                  .contains(symptoms)) {
                                                selectedSymptoms.add(symptoms);
                                              }
                                            } else {
                                              if (selectedSymptoms
                                                  .contains(symptoms)) {
                                                selectedSymptoms
                                                    .remove(symptoms);
                                              }
                                            }
                                            controller.setSelectedSymptoms(
                                                selectedSymptoms);
                                            controller.update();
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                    .getSelectedSymptoms()
                                                    .contains(symptoms)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
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
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                  children: controller.vaginal_discharge
                                      .map(
                                        (vaginalDischarge) => ChoiceChip(
                                          label: Text(vaginalDischarge),
                                          selected: controller
                                                  .getSelectedVaginalDischarge() ==
                                              vaginalDischarge,
                                          onSelected: (bool isSelected) {
                                            if (isSelected) {
                                              controller
                                                  .setSelectedVaginalDischarge(
                                                      vaginalDischarge);
                                            } else {
                                              controller
                                                  .setSelectedVaginalDischarge(
                                                      "");
                                            }
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                        .getSelectedVaginalDischarge() ==
                                                    vaginalDischarge
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
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
                        color: Colors.white.withOpacity(0.10000000149011612),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                  children: controller.symptoms
                                      .map(
                                        (symptoms) => FilterChip(
                                          label: Text(symptoms),
                                          selected: controller
                                              .getSelectedMoods()
                                              .contains(symptoms),
                                          onSelected: (bool isSelected) {
                                            List<String> selectedSymptoms =
                                                List.from(controller
                                                    .getSelectedMoods());

                                            if (isSelected) {
                                              if (!selectedSymptoms
                                                  .contains(symptoms)) {
                                                selectedSymptoms.add(symptoms);
                                              }
                                            } else {
                                              if (selectedSymptoms
                                                  .contains(symptoms)) {
                                                selectedSymptoms
                                                    .remove(symptoms);
                                              }
                                            }
                                            controller.setSelectedMoods(
                                                selectedSymptoms);
                                            controller.update();
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                    .getSelectedMoods()
                                                    .contains(symptoms)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
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
                        color: Colors.white.withOpacity(0.10000000149011612),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 3, color: Color(0xFFF4F4F4)),
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                                        (others) => FilterChip(
                                          label: Text(others),
                                          selected: controller
                                              .getSelectedOthers()
                                              .contains(others),
                                          onSelected: (bool isSelected) {
                                            List<String> selectedSymptoms =
                                                List.from(controller
                                                    .getSelectedOthers());

                                            if (isSelected) {
                                              if (!selectedSymptoms
                                                  .contains(others)) {
                                                selectedSymptoms.add(others);
                                              }
                                            } else {
                                              if (selectedSymptoms
                                                  .contains(others)) {
                                                selectedSymptoms.remove(others);
                                              }
                                            }
                                            controller.setSelectedOthers(
                                                selectedSymptoms);
                                            controller.update();
                                          },
                                          labelStyle: TextStyle(
                                            color: controller
                                                    .getSelectedOthers()
                                                    .contains(others)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: Colors.transparent,
                                          selectedColor: Color(0xFF34C2C1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
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
                                                  .wholeNumberTemperature.value,
                                              onChanged: controller
                                                  .onWholeNumberTemperatureChanged,
                                              textStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 20.sp),
                                              selectedTextStyle: TextStyle(
                                                color: Color(0xFFFF6868),
                                                fontSize: 23.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              infiniteLoop: true,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ".",
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
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
                                              textStyle:
                                                  TextStyle(color: Colors.grey),
                                              selectedTextStyle: TextStyle(
                                                color: Color(0xFFFF6868),
                                                fontSize: 20.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              infiniteLoop: true,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " °C",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF6868),
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
                                            backgroundColor: Color(0xFFFD6666),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            minimumSize: Size(Get.width, 45.h)),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
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
                            // height: 120.h,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 3,
                                  color: Color(0xFFF4F4F4),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  Icon(Iconsax.wind),
                                  SizedBox(width: 20.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        final temperatureValue =
                                            controller.temperatures.value;
                                        return temperatureValue.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Temperature",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      height: 2.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: "$temperatureValue",
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFFFD6666),
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: ' °C',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
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
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              );
                                      }),
                                    ],
                                  ),
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
                                                  .wholeNumberWeight.value,
                                              onChanged: controller
                                                  .onWholeNumberWeightChanged,
                                              textStyle:
                                                  TextStyle(color: Colors.grey),
                                              selectedTextStyle: TextStyle(
                                                color: Color(0xFFFF6868),
                                                fontSize: 23.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              infiniteLoop: true,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ".",
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Obx(
                                            () => NumberPicker(
                                              minValue: 0,
                                              maxValue: 9,
                                              value: controller
                                                  .decimalNumberWeight.value,
                                              onChanged: controller
                                                  .onDecimalNumberWeightChanged,
                                              textStyle:
                                                  TextStyle(color: Colors.grey),
                                              selectedTextStyle: TextStyle(
                                                color: Color(0xFFFF6868),
                                                fontSize: 23.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              infiniteLoop: true,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " Kg",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFFF6868),
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
                                            backgroundColor: Color(0xFFFD6666),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            minimumSize: Size(Get.width, 45.h)),
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
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
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 3,
                                  color: Color(0xFFF4F4F4),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.w),
                                  Icon(Iconsax.weight),
                                  SizedBox(width: 20.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Obx(() {
                                        final weightValue =
                                            controller.weights.value;
                                        return weightValue.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Weight",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      height: 2.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text.rich(
                                                    TextSpan(
                                                      text: "$weightValue",
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFFFD6666),
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: ' Kg',
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
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
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      children: [
                        Container(
                          width: Get.width,
                          decoration: ShapeDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 3,
                                color: Color(0xFFF4F4F4),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                Icon(Iconsax.clock4),
                                SizedBox(width: 20.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      final weightValue =
                                          controller.weights.value;
                                      return weightValue.isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Custom Reminder",
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    height: 2.0,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              "Custom Reminder",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                height: 2.0,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            );
                                    }),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: Get.height,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 35.h),
                                                  Icon(
                                                    Iconsax.clock4,
                                                    size: 35,
                                                    color: Color(0xFFFF6868),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Text(
                                                    "Custom Reminder",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      letterSpacing: 0.8,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  TextFormField(
                                                    controller:
                                                        controller.reminderName,
                                                    autocorrect: false,
                                                    decoration: InputDecoration(
                                                      labelText: "Event",
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),

                                                  // ElevatedButton(
                                                  //   onPressed: () {
                                                  //     Navigator.pop(context);
                                                  //   },
                                                  //   style: ElevatedButton.styleFrom(
                                                  //       backgroundColor:
                                                  //           Color(0xFFFD6666),
                                                  //       shape: RoundedRectangleBorder(
                                                  //           borderRadius:
                                                  //               BorderRadius
                                                  //                   .circular(
                                                  //                       30)),
                                                  //       minimumSize: Size(
                                                  //           Get.width, 45.h)),
                                                  //   child: Text(
                                                  //     "Save",
                                                  //     style: TextStyle(
                                                  //       fontFamily: 'Poppins',
                                                  //       fontSize: 16.sp,
                                                  //       fontWeight:
                                                  //           FontWeight.w600,
                                                  //       letterSpacing: 0.38,
                                                  //       color: Colors.white,
                                                  //     ),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Iconsax.add4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
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
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        TextFormField(
                                          minLines: 7,
                                          maxLines: 7,
                                          style: TextStyle(fontSize: 14),
                                          onChanged: (text) =>
                                              controller.notes.value = text,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFFD6666),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            minimumSize: Size(Get.width, 45.h),
                                          ),
                                          child: Text(
                                            "Save",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
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
                              color: Colors.white.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 3,
                                  color: Color(0xFFF4F4F4),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.w),
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Obx(
                                          () => controller
                                                  .notes.value.isNotEmpty
                                              ? Text(
                                                  "${controller.notes.value}",
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFFD6666),
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
