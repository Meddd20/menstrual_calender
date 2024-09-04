import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/blood_pressure_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class BloodPressureView extends GetView<BloodPressureController> {
  const BloodPressureView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BloodPressureController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Blood Pressure",
              style: CustomTextStyle.extraBold(20),
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
                return Obx(
                  () => SafeArea(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.h),
                      height: Get.height * 0.97,
                      width: Get.width,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Add Blood Pressure",
                                style: CustomTextStyle.extraBold(20, height: 1.5),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TableCalendar(
                                  focusedDay: controller.getFocusedDate,
                                  firstDay: controller.tanggalAwalMinggu.first,
                                  lastDay: DateTime.now(),
                                  startingDayOfWeek: StartingDayOfWeek.monday,
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
                                    formatButtonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      color: Colors.red,
                                    ),
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
                              SizedBox(height: 5),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Time",
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
                                        "Systolic",
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
                                        "Diastolic",
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
                                        "Pulse",
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
                              text: "Add",
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
        body: Obx(
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
                              "${formatToDayHour(entry.datetime)}",
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
                      xValueMapper: (BloodPressure data, _) => formatToDayHour(data.datetime),
                      highValueMapper: (BloodPressure data, _) => data.systolicPressure,
                      lowValueMapper: (BloodPressure data, _) => data.diastolicPressure,
                      width: 0.2,
                      color: AppColors.highlight,
                      enableTooltip: true,
                    ),
                    ScatterSeries<BloodPressure, String>(
                      dataSource: controller.allBloodPressure,
                      xValueMapper: (BloodPressure data, _) => formatToDayHour(data.datetime),
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
                      xValueMapper: (BloodPressure data, _) => formatToDayHour(data.datetime),
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
                              "Pressure",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              "Pulse",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              "Date",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              "Time",
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
                                  DateFormat('dd.MM').format(DateTime.tryParse(bloodPressure.datetime) ?? DateTime.now()),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  DateFormat('HH:mm').format(DateTime.tryParse(bloodPressure.datetime) ?? DateTime.now()),
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
                                      builder: (BuildContext context) {
                                        return Wrap(
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
                                                          return Obx(
                                                            () => Container(
                                                              padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.h),
                                                              height: Get.height * 0.97,
                                                              width: Get.width,
                                                              child: Stack(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: Text(
                                                                              "Edit Blood Pressure",
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
                                                                      SizedBox(height: 10),
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        child: TableCalendar(
                                                                          focusedDay: controller.getFocusedDate,
                                                                          firstDay: controller.tanggalAwalMinggu.first,
                                                                          lastDay: DateTime.now(),
                                                                          startingDayOfWeek: StartingDayOfWeek.monday,
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
                                                                            formatButtonDecoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              border: Border.all(
                                                                                color: Colors.black,
                                                                                width: 2,
                                                                              ),
                                                                              color: Colors.red,
                                                                            ),
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
                                                                      SizedBox(height: 5),
                                                                      Container(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Time",
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
                                                                                "Systolic",
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
                                                                                "Diastolic",
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
                                                                                "Pulse",
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
                                                                      text: "Edit",
                                                                      onPressed: () {
                                                                        controller.editBloodPressure(context, bloodPressure.id!);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
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
                                                              "Edit Blood Pressure",
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
                                                              "Delete Blood Pressure",
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
