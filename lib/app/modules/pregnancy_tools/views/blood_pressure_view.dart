import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/blood_pressure_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class BloodPressureView extends GetView<BloodPressureController> {
  const BloodPressureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BloodPressureController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.bloodPressure,
                  style: CustomTextStyle.extraBold(20),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.w, 50.h, 15.w, 0.h),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!.bloodPressureInfo,
                                        style: CustomTextStyle.extraBold(22, height: 1.5),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!.bloodPressureInfoDesc,
                                  style: CustomTextStyle.medium(16, height: 1.75),
                                ),
                                SizedBox(height: 30),
                                Divider(
                                  height: 0.5,
                                  thickness: 1.0,
                                ),
                                SizedBox(height: 15),
                                Container(
                                  child: Text(
                                    AppLocalizations.of(context)!.medicalDisclaimer,
                                    style: CustomTextStyle.medium(12),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  AppLocalizations.of(context)!.medicalDisclaimerDesc,
                                  style: CustomTextStyle.light(12, height: 1.5),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
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
      ),
      extendBodyBehindAppBar: false,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          AppLocalizations.of(context)!.add,
          style: CustomTextStyle.bold(14, color: AppColors.white),
        ),
        icon: Icon(Icons.add),
        elevation: 0.0,
        tooltip: AppLocalizations.of(context)!.addNewWeightGain,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SafeArea(
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.fromLTRB(10.w, 25.h, 10.w, 0.h),
                    width: Get.width,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocalizations.of(context)!.addBloodPressure,
                                    style: CustomTextStyle.extraBold(20, height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    controller.resetBloodPressure();
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CustomExpandedCalendar(
                                firstDay: controller.tanggalAwalMinggu.first,
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
                            SizedBox(height: 5),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.time,
                                      style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
                                        if (selectedTime != null) {
                                          controller.setTime(selectedTime);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          controller.formattedSelectedTime != null ? "${controller.formattedSelectedTime}" : "Time",
                                          style: CustomTextStyle.bold(16, color: AppColors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.systolic,
                                      style: CustomTextStyle.semiBold(14, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    NumberPicker(
                                      minValue: 40,
                                      maxValue: 300,
                                      value: controller.getSystolicPressure ?? 120,
                                      onChanged: (int systolic) {
                                        controller.setSystolicPressure(systolic);
                                      },
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
                                  ],
                                ),
                                SizedBox(width: 5),
                                Column(
                                  children: [
                                    SizedBox(height: 28),
                                    Text(
                                      "/",
                                      style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5),
                                Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.diastolic,
                                      style: CustomTextStyle.semiBold(14, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    NumberPicker(
                                      minValue: 40,
                                      maxValue: 300,
                                      value: controller.getDiastolicPressure ?? 80,
                                      onChanged: (int diastolic) {
                                        controller.setDiastolicPressure(diastolic);
                                      },
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
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.pulse,
                                      style: CustomTextStyle.semiBold(14, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    NumberPicker(
                                      minValue: 40,
                                      maxValue: 300,
                                      value: controller.getPulse ?? 60,
                                      onChanged: (int pulse) {
                                        controller.setPulse(pulse);
                                      },
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
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 15,
                          left: 0,
                          right: 0,
                          child: CustomButton(
                            text: AppLocalizations.of(context)!.add,
                            onPressed: () {
                              controller.addBloodPressure(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).then((value) {
            controller.resetBloodPressure();
          });
        },
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                      final BloodPressure entry = controller.allBloodPressure[pointIndex];

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${formatDateToDayHour(entry.datetime)}",
                              style: CustomTextStyle.bold(12, color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${entry.systolicPressure}/${entry.diastolicPressure} mmHg",
                              style: CustomTextStyle.bold(12, color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${entry.heartRate} BPM",
                              style: CustomTextStyle.bold(12, color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                    initialVisibleMaximum: 7,
                    labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    autoScrollingMode: AutoScrollingMode.end,
                    isInversed: true,
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 40,
                    interval: 20,
                  ),
                  enableSideBySideSeriesPlacement: false,
                  series: [
                    RangeColumnSeries<BloodPressure, String>(
                      dataSource: controller.allBloodPressure,
                      xValueMapper: (BloodPressure data, _) => formatDateToDayHour(data.datetime),
                      highValueMapper: (BloodPressure data, _) => data.systolicPressure,
                      lowValueMapper: (BloodPressure data, _) => data.diastolicPressure,
                      width: 0.2,
                      color: AppColors.highlight,
                      enableTooltip: true,
                    ),
                    ScatterSeries<BloodPressure, String>(
                      dataSource: controller.allBloodPressure,
                      xValueMapper: (BloodPressure data, _) => formatDateToDayHour(data.datetime),
                      yValueMapper: (BloodPressure data, _) => data.systolicPressure,
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.rectangle,
                        color: Colors.red,
                        borderWidth: 0,
                        width: 15,
                        height: 15,
                      ),
                      enableTooltip: false,
                    ),
                    ScatterSeries<BloodPressure, String>(
                      dataSource: controller.allBloodPressure,
                      xValueMapper: (BloodPressure data, _) => formatDateToDayHour(data.datetime),
                      yValueMapper: (BloodPressure data, _) => data.diastolicPressure,
                      markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.rectangle,
                        color: Colors.green,
                        borderWidth: 0,
                        width: 15,
                        height: 15,
                      ),
                      enableTooltip: false,
                    ),
                  ],
                ),
                Container(
                  width: Get.width,
                  child: DataTable(
                    columnSpacing: 20.0,
                    dataRowMinHeight: 50.0,
                    dataRowMaxHeight: 70.0,
                    dividerThickness: 0,
                    sortAscending: true,
                    headingTextStyle: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                    dataTextStyle: CustomTextStyle.semiBold(14, height: 1.5),
                    columns: [
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.pressure,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.pulse,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.dates,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.time,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text(""))),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      controller.allBloodPressure.length,
                      (index) {
                        final bloodPressure = controller.allBloodPressure[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${bloodPressure.systolicPressure} / ${bloodPressure.diastolicPressure}\n",
                                        style: CustomTextStyle.semiBold(14, height: 1.5),
                                      ),
                                      TextSpan(
                                        text: "mmHg",
                                        style: CustomTextStyle.regular(12, height: 1.5, color: Colors.black.withOpacity(0.5)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  bloodPressure.heartRate.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  formatShortDate(bloodPressure.datetime),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  formatHourMinute(DateTime.tryParse(bloodPressure.datetime) ?? DateTime.now()),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.more_vert_outlined),
                                  color: Colors.black.withOpacity(0.4),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      useSafeArea: true,
                                      builder: (BuildContext context) {
                                        return Container(
                                          child: Wrap(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        controller.setSystolicPressure(bloodPressure.systolicPressure);
                                                        controller.setDiastolicPressure(bloodPressure.diastolicPressure);
                                                        controller.setPulse(bloodPressure.heartRate);
                                                        controller.setTime(TimeOfDay.fromDateTime(DateTime.parse(bloodPressure.datetime)));
                                                        controller.setSelectedDate(DateTime.parse(bloodPressure.datetime));
                                                        controller.setFocusedDate(DateTime.parse(bloodPressure.datetime));
                                                        showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled: true,
                                                          builder: (BuildContext context) {
                                                            return SafeArea(
                                                              child: Obx(
                                                                () => Container(
                                                                  padding: EdgeInsets.fromLTRB(10.w, 25.h, 10.w, 0.h),
                                                                  width: Get.width,
                                                                  child: Stack(
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  AppLocalizations.of(context)!.editBloodPressure,
                                                                                  style: CustomTextStyle.extraBold(20, height: 1.5),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                              IconButton(
                                                                                icon: Icon(Icons.close),
                                                                                onPressed: () {
                                                                                  controller.resetBloodPressure();
                                                                                  Get.back();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: CustomExpandedCalendar(
                                                                              firstDay: controller.tanggalAwalMinggu.first,
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
                                                                          SizedBox(height: 5),
                                                                          Container(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.time,
                                                                                    style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () async {
                                                                                      TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
                                                                                      if (selectedTime != null) {
                                                                                        controller.setTime(selectedTime);
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppColors.primary,
                                                                                        borderRadius: BorderRadius.circular(12),
                                                                                      ),
                                                                                      child: Text(
                                                                                        controller.formattedSelectedTime != null ? "${controller.formattedSelectedTime}" : AppLocalizations.of(context)!.time,
                                                                                        style: CustomTextStyle.bold(16, color: AppColors.white),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(height: 10),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              Column(
                                                                                children: [
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.systolic,
                                                                                    style: CustomTextStyle.semiBold(14, height: 1.5),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  NumberPicker(
                                                                                    minValue: 40,
                                                                                    maxValue: 300,
                                                                                    value: controller.getSystolicPressure ?? 120,
                                                                                    onChanged: (int systolic) {
                                                                                      controller.setSystolicPressure(systolic);
                                                                                    },
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
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              Column(
                                                                                children: [
                                                                                  SizedBox(height: 28),
                                                                                  Text(
                                                                                    "/",
                                                                                    style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              Column(
                                                                                children: [
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.diastolic,
                                                                                    style: CustomTextStyle.semiBold(14, height: 1.5),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  NumberPicker(
                                                                                    minValue: 40,
                                                                                    maxValue: 300,
                                                                                    value: controller.getDiastolicPressure ?? 80,
                                                                                    onChanged: (int diastolic) {
                                                                                      controller.setDiastolicPressure(diastolic);
                                                                                    },
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
                                                                                ],
                                                                              ),
                                                                              SizedBox(width: 10),
                                                                              Column(
                                                                                children: [
                                                                                  Text(
                                                                                    AppLocalizations.of(context)!.pulse,
                                                                                    style: CustomTextStyle.semiBold(14, height: 1.5),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  NumberPicker(
                                                                                    minValue: 40,
                                                                                    maxValue: 300,
                                                                                    value: controller.getPulse ?? 60,
                                                                                    onChanged: (int pulse) {
                                                                                      controller.setPulse(pulse);
                                                                                    },
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
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Positioned(
                                                                        bottom: 15,
                                                                        left: 0,
                                                                        right: 0,
                                                                        child: CustomButton(
                                                                          text: AppLocalizations.of(context)!.edit,
                                                                          onPressed: () {
                                                                            controller.editBloodPressure(context, bloodPressure.id!);
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) {
                                                          controller.resetBloodPressure();
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 16, right: 16),
                                                        height: 50,
                                                        width: Get.width,
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(context)!.editBloodPressure,
                                                                style: CustomTextStyle.bold(14),
                                                              ),
                                                              Icon(Icons.edit)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    InkWell(
                                                      onTap: () => controller.deleteBloodPressure(context, bloodPressure.id!),
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 16, right: 16),
                                                        height: 50,
                                                        width: Get.width,
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(context)!.deleteBloodPressure,
                                                                style: CustomTextStyle.bold(14),
                                                              ),
                                                              Icon(Icons.delete)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
