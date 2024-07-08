import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_gain_tracker_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/init_weight_gain_tracker_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WeightGainView extends GetView<WeightGainTrackerController> {
  const WeightGainView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeightGainTrackerController controller = Get.put(WeightGainTrackerController());

    return FutureBuilder<void>(
      future: controller.weightGainIndexData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          return controller.weightGainHistory.isEmpty ? InitWeightGainTrackerView() : WeightGainTrackerView();
        }
      },
    );
  }
}

class WeightGainTrackerView extends GetView<WeightGainTrackerController> {
  const WeightGainTrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WeightGainTrackerController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weight Gain Tracker'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Add"),
          icon: Icon(Icons.add),
          elevation: 0.0,
          tooltip: "Add new weight gain data",
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Obx(
                    () => Container(
                      padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                      height: Get.height * 0.92,
                      width: Get.width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "Add New Weight",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 246, 245, 245),
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
                                    controller.getSelectedWeek(selectedDay);
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
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      color: AppColors.contrast,
                                    ),
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
                                  calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                                    return Center(
                                      child: Text(
                                        DateFormat.E().format(day),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }, defaultBuilder: (context, day, focusedDay) {
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
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
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
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
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    return null;
                                  }),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Selected Date",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${DateFormat('yyyy-MM-dd').format(controller.selectedDate ?? DateTime.now())}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pregnancy Week",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "${controller.selectedWeek}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumberPicker(
                                  minValue: 30,
                                  maxValue: 150,
                                  value: controller.selectedWeight ?? 0,
                                  onChanged: controller.setSelectedWeight,
                                  textStyle: TextStyle(color: Colors.grey),
                                  selectedTextStyle: TextStyle(
                                    color: Color(0xFFFF6868),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  infiniteLoop: true,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.black),
                                      bottom: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Text(
                                  ".",
                                  style: TextStyle(
                                    color: Color(0xFFFF6868),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                NumberPicker(
                                  minValue: 0,
                                  maxValue: 9,
                                  value: controller.selectedWeightDecimal ?? 0,
                                  onChanged: controller.setSelectedWeightDecimal,
                                  textStyle: TextStyle(color: Colors.grey),
                                  selectedTextStyle: TextStyle(
                                    color: Color(0xFFFF6868),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  infiniteLoop: true,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.black),
                                      bottom: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Kg",
                                  style: TextStyle(
                                    color: Color(0xFFFF6868),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                controller.weeklyWeightGain();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFD6666), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), minimumSize: Size(Get.width, 45.h)),
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
                }).then((value) {
              controller.resetValue();
            });
          },
        ),
        body: FutureBuilder(
          future: controller.weightGainIndexData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Obx(
                () => Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: Get.height * 0.37,
                          child: SfCartesianChart(
                            onTrackballPositionChanging: (trackballArgs) {
                              if (trackballArgs.chartPointInfo.seriesIndex == 0) {
                                trackballArgs.chartPointInfo.label = 'Recommend Weight \n Week-${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].week} \n  ${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].recommendWeightLower} - ${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].recommendWeightUpper} kg';
                              } else {
                                trackballArgs.chartPointInfo.label = 'Week-${controller.weightGainHistory[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].mingguKehamilan} \n ${controller.weightGainHistory[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].beratBadan} kg';
                              }
                            },
                            trackballBehavior: TrackballBehavior(
                              enable: true,
                              lineType: TrackballLineType.vertical,
                              tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                              activationMode: ActivationMode.singleTap,
                              tooltipAlignment: ChartAlignment.center,
                              shouldAlwaysShow: true,
                            ),
                            // backgroundColor: Colors.white,
                            primaryXAxis: NumericAxis(
                              minimum: 0,
                              maximum: 40,
                              title: AxisTitle(
                                text: 'Weeks of Pregnancy',
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                              majorTickLines: MajorTickLines(size: 0),
                              majorGridLines: MajorGridLines(width: 0),
                              labelFormat: '{value}' + "",
                              labelStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black,
                              ),
                              interval: 1,
                              axisLabelFormatter: (AxisLabelRenderDetails details) {
                                if (details.value == 13 || details.value == 28 || details.value == 40) {
                                  return ChartAxisLabel(details.text, details.textStyle);
                                } else {
                                  return ChartAxisLabel('', details.textStyle);
                                }
                              },
                            ),
                            primaryYAxis: NumericAxis(
                              minimum: controller.getMinYAxisValue(controller.weightGainHistory, controller.reccomendWeightGain),
                              maximum: controller.reccomendWeightGain.map((data) => data.recommendWeightUpper!).reduce((value, element) => value > element ? value : element) + 1,
                              labelStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.black,
                              ),
                              title: AxisTitle(
                                text: 'Weight Gain (kg)',
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            series: [
                              RangeAreaSeries<RecommendWeightGain, int>(
                                dataSource: controller.reccomendWeightGain,
                                name: 'Recommended Weight Gain Range',
                                xValueMapper: (RecommendWeightGain data, _) => data.week!,
                                highValueMapper: (RecommendWeightGain data, _) => data.recommendWeightUpper!,
                                lowValueMapper: (RecommendWeightGain data, _) => data.recommendWeightLower!,
                                markerSettings: MarkerSettings(),
                                color: AppColors.highlight,
                              ),
                              LineSeries<WeightHistory, int>(
                                dataSource: controller.weightGainHistory,
                                name: 'Actual Weight Gain',
                                xValueMapper: (WeightHistory data, _) => data.mingguKehamilan!,
                                yValueMapper: (WeightHistory data, _) => data.beratBadan!,
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  color: AppColors.primary,
                                  borderWidth: 0.0,
                                ),
                                enableTooltip: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 232, 232, 232),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${(controller.getPregnancyWeightGainData?.prepregnancyWeight ?? 0).toStringAsFixed(1)} Kg",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Starting",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        height: 1.25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${(controller.getPregnancyWeightGainData?.currentWeight ?? 0).toStringAsFixed(1)} Kg",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Current",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        height: 1.25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${(controller.getPregnancyWeightGainData?.totalGain ?? 0).toStringAsFixed(1)} Kg",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Total Gain",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        height: 1.25,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 232, 232, 232),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Reccomended Weight Gain",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${controller.getPregnancyWeightGainData?.currentWeekReccomendWeight ?? 0} Kg",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Current Week \n(Week ${controller.getPregnancyWeightGainData?.week ?? 0})",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            height: 1.25,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${controller.getPregnancyWeightGainData?.nextWeekReccomendWeight ?? 0} Kg",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "Next Week \n(Week ${(controller.getPregnancyWeightGainData?.week ?? 0) + 1})",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            height: 1.25,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Previous Record",
                            style: TextStyle(
                              fontSize: 20.sp,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: Get.width,
                          child: DataTable(
                            columnSpacing: 20.0,
                            dataRowMinHeight: 50.0,
                            dataRowMaxHeight: 60.0,
                            dividerThickness: 0,
                            sortAscending: true,
                            headingTextStyle: TextStyle(
                              fontSize: 14.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            dataTextStyle: TextStyle(
                              fontSize: 14.sp,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            columns: [
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Weight",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Date",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Week",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Gain",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(""),
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(
                              controller.weightGainHistory.length,
                              (index) {
                                final weightData = controller.weightGainHistory[index];
                                final isEvenRow = index % 2 == 0;
                                final rowColor = isEvenRow ? Colors.pink[50] : null;
                                final DateTime? parsedDate = weightData.tanggalPencatatan != null ? DateTime.tryParse(weightData.tanggalPencatatan!) : null;
                                final formattedDate = parsedDate != null ? DateFormat('dd.MM').format(parsedDate) : 'Invalid date';
                                DateTime? tanggalPencatatan = DateTime.tryParse(weightData.tanggalPencatatan ?? '');

                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                                    return rowColor;
                                  }),
                                  cells: [
                                    DataCell(
                                      Center(
                                        child: Text(
                                          '${weightData.beratBadan?.toStringAsFixed(1)} kg',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          formattedDate,
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          '${weightData.mingguKehamilan}',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          '${weightData.pertambahanBerat?.toStringAsFixed(1) ?? "0"} kg',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: (weightData.pertambahanBerat ?? 0) < 0
                                                ? Colors.red
                                                : (weightData.pertambahanBerat ?? 0) == 0
                                                    ? Colors.black
                                                    : Colors.green,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: GestureDetector(
                                          child: Icon(Icons.more_vert_outlined, size: 16),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Obx(() => Wrap(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                              height: 4.h,
                                                              width: 32.w,
                                                              margin: EdgeInsets.only(top: 16.h),
                                                              decoration: BoxDecoration(
                                                                color: Colors.blueGrey,
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(3.0),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 10.h),
                                                            Padding(
                                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  controller.setFocusedDate(tanggalPencatatan ?? DateTime.now());
                                                                  controller.setSelectedDate(tanggalPencatatan ?? DateTime.now());
                                                                  controller.setSelectedWeek(weightData.mingguKehamilan ?? 0);
                                                                  controller.setSelectedWeight(weightData.beratBadan?.floor() ?? 0);
                                                                  controller.setSelectedWeightDecimal((weightData.beratBadan! * 10 % 10).toInt());
                                                                  controller.isTwin.value = (controller.pregnancyWeightGainData.value?.isTwin == 0) ? true : false;

                                                                  final height = controller.pregnancyWeightGainData.value?.prepregnancyHeight;

                                                                  if (height != null) {
                                                                    controller.setSelectedInitHeight(height.floor());
                                                                    controller.setSelectedInitHeightDecimal((height * 10 % 10).toInt());
                                                                    controller.updateHeight();
                                                                  } else {
                                                                    controller.setSelectedInitHeight(height?.floor() ?? 125);
                                                                    controller.setSelectedInitHeightDecimal(0);
                                                                  }
                                                                  if (index != controller.weightGainHistory.length - 1)
                                                                    showModalBottomSheet(
                                                                        context: context,
                                                                        isScrollControlled: true,
                                                                        builder: (BuildContext context) {
                                                                          return Obx(
                                                                            () => Container(
                                                                              padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                                                                              height: Get.height * 0.92,
                                                                              width: Get.width,
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    "Edit Weight",
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontSize: 20,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 20),
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      color: Color.fromARGB(255, 246, 245, 245),
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
                                                                                        controller.getSelectedWeek(selectedDay);
                                                                                      },
                                                                                      onPageChanged: (focusedDay) {
                                                                                        controller.setFocusedDate(focusedDay);
                                                                                      },
                                                                                      selectedDayPredicate: (day) => isSameDay(
                                                                                        controller.selectedDate,
                                                                                        day,
                                                                                      ),
                                                                                      currentDay: controller.selectedDate,
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
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(10),
                                                                                            topRight: Radius.circular(10),
                                                                                          ),
                                                                                          color: AppColors.contrast,
                                                                                        ),
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
                                                                                      calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                                                                                        return Center(
                                                                                          child: Text(
                                                                                            DateFormat.E().format(day),
                                                                                            style: TextStyle(
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      }, defaultBuilder: (context, day, focusedDay) {
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
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 16,
                                                                                              ),
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
                                                                                              style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                fontSize: 16,
                                                                                              ),
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
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontSize: 12,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          }
                                                                                        }
                                                                                        return null;
                                                                                      }),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Selected Date",
                                                                                          style: TextStyle(
                                                                                            color: Colors.black.withOpacity(0.5),
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontSize: 14,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          "${DateFormat('yyyy-MM-dd').format(controller.selectedDate ?? DateTime.now())}",
                                                                                          style: TextStyle(
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.w700,
                                                                                            fontSize: 16,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Obx(() => Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              "Pregnancy Week",
                                                                                              style: TextStyle(
                                                                                                color: Colors.black.withOpacity(0.5),
                                                                                                fontWeight: FontWeight.w400,
                                                                                                fontSize: 14,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              "${controller.selectedWeek}",
                                                                                              style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontWeight: FontWeight.w700,
                                                                                                fontSize: 16,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      )),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      NumberPicker(
                                                                                        minValue: 30,
                                                                                        maxValue: 150,
                                                                                        value: controller.selectedWeight ?? 0,
                                                                                        onChanged: controller.setSelectedWeight,
                                                                                        textStyle: TextStyle(color: Colors.grey),
                                                                                        selectedTextStyle: TextStyle(
                                                                                          color: Color(0xFFFF6868),
                                                                                          fontSize: 24.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        infiniteLoop: true,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border(
                                                                                            top: BorderSide(color: Colors.black),
                                                                                            bottom: BorderSide(color: Colors.black),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Text(
                                                                                        ".",
                                                                                        style: TextStyle(
                                                                                          color: Color(0xFFFF6868),
                                                                                          fontSize: 24.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                      NumberPicker(
                                                                                        minValue: 0,
                                                                                        maxValue: 9,
                                                                                        value: controller.selectedWeightDecimal ?? 0,
                                                                                        onChanged: controller.setSelectedWeightDecimal,
                                                                                        textStyle: TextStyle(color: Colors.grey),
                                                                                        selectedTextStyle: TextStyle(
                                                                                          color: Color(0xFFFF6868),
                                                                                          fontSize: 24.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        infiniteLoop: true,
                                                                                        decoration: BoxDecoration(
                                                                                          border: Border(
                                                                                            top: BorderSide(color: Colors.black),
                                                                                            bottom: BorderSide(color: Colors.black),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(width: 10),
                                                                                      Text(
                                                                                        "Kg",
                                                                                        style: TextStyle(
                                                                                          color: Color(0xFFFF6868),
                                                                                          fontSize: 20.sp,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: 10),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      controller.weeklyWeightGain();
                                                                                      Navigator.of(context).popUntil((route) {
                                                                                        return route.settings.name == '/WeightGainTrackerView';
                                                                                      });
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFD6666), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), minimumSize: Size(Get.width, 45.h)),
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
                                                                          );
                                                                        }).then((value) {
                                                                      Navigator.of(context).popUntil((route) {
                                                                        return route.settings.name == '/WeightGainView';
                                                                      });
                                                                      controller.resetValue();
                                                                    });
                                                                  else {
                                                                    Get.to(() => InitWeightGainTrackerView());
                                                                  }
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
                                                                          "Edit Weight Data",
                                                                          style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                        Icon(Icons.delete)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (index != controller.weightGainHistory.length - 1)
                                                              Container(
                                                                padding: EdgeInsets.only(left: 25, right: 25),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    controller.deleteWeeklyWeightGain(weightData.id ?? 0);
                                                                    Get.back();
                                                                    controller.focusNode.unfocus();
                                                                  },
                                                                  child: Container(
                                                                    height: 50,
                                                                    width: Get.width,
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Delete Weight Data",
                                                                            style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          Icon(Icons.delete),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            SizedBox(height: 10.h),
                                                          ],
                                                        ),
                                                      ],
                                                    ));
                                              },
                                            ).then((value) {
                                              controller.focusNode.unfocus();
                                            });
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
                        SizedBox(height: 60),
                      ],
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
