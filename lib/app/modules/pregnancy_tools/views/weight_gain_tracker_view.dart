import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_gain_tracker_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

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
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                  height: Get.height,
                  width: Get.width,
                  child: Column(
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
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Initialize Weight Gain Tracker",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 25,
                                          color: Color(0xFFFD6666),
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    width: Get.width,
                                    child: Text(
                                      "Update the start and end dates of a specific time period for precise and current tracking.",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
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
        body: FutureBuilder(
          future: controller.weightGainIndexData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Obx(() => Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // padding: const EdgeInsets.all(8.0),
                            // width: Get.width,
                            height: Get.height * 0.37,
                            child: SfCartesianChart(
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                builder: (dynamic data,
                                    dynamic point,
                                    dynamic series,
                                    int pointIndex,
                                    int seriesIndex) {
                                  if (seriesIndex == 0) {
                                    ReccomendWeightGain reccomendWeightData =
                                        controller
                                            .reccomendWeightGain[pointIndex];
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'Week #${reccomendWeightData.week}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center),
                                          Text(
                                            "Reccomend Weight Range",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            '${reccomendWeightData.reccomendWeightLower?.toStringAsFixed(1)} kg - ${reccomendWeightData.reccomendWeightUpper?.toStringAsFixed(1)} kg',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    WeightHistory weightData = controller
                                        .weightGainHistory[pointIndex];
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Minggu ${weightData.mingguKehamilan}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Tanggal: ${weightData.tanggalPencatatan.toString().substring(0, 10)}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Berat Badan: ${weightData.beratBadan} kg',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Pertambahan Berat: ${weightData.pertambahanBerat?.toStringAsFixed(1) == null ? 0 : weightData.pertambahanBerat?.toStringAsFixed(1)} kg',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                              trackballBehavior: TrackballBehavior(
                                enable: true,
                                lineType: TrackballLineType.vertical,
                                tooltipSettings: InteractiveTooltip(
                                  enable: true,
                                  format:
                                      '#Week point.x \n  point.low - point.high kg',
                                ),
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
                                axisLabelFormatter:
                                    (AxisLabelRenderDetails details) {
                                  if (details.value == 13 ||
                                      details.value == 28 ||
                                      details.value == 40) {
                                    return ChartAxisLabel(
                                        details.text, details.textStyle);
                                  } else {
                                    return ChartAxisLabel(
                                        '', details.textStyle);
                                  }
                                },
                              ),
                              primaryYAxis: NumericAxis(
                                minimum: controller.reccomendWeightGain
                                    .map((data) => data.reccomendWeightLower!)
                                    .reduce((value, element) =>
                                        value < element ? value : element),
                                maximum: controller.reccomendWeightGain
                                        .map((data) =>
                                            data.reccomendWeightUpper!)
                                        .reduce((value, element) =>
                                            value > element ? value : element) +
                                    1,
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
                                RangeAreaSeries<ReccomendWeightGain, int>(
                                  dataSource: controller.reccomendWeightGain,
                                  name: 'Recommended Weight Gain Range',
                                  xValueMapper: (ReccomendWeightGain data, _) =>
                                      data.week!,
                                  highValueMapper:
                                      (ReccomendWeightGain data, _) =>
                                          data.reccomendWeightUpper!,
                                  lowValueMapper:
                                      (ReccomendWeightGain data, _) =>
                                          data.reccomendWeightLower!,
                                  markerSettings: MarkerSettings(),
                                  color: AppColors.highlight,
                                ),
                                LineSeries<WeightHistory, int>(
                                  dataSource: controller.weightGainHistory,
                                  name: 'Actual Weight Gain',
                                  xValueMapper: (WeightHistory data, _) =>
                                      data.mingguKehamilan!,
                                  yValueMapper: (WeightHistory data, _) =>
                                      data.beratBadan!,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${controller.getPregnancyWeightGainData?.prepregnancyWeight ?? 0} Kg",
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
                                        "${controller.getPregnancyWeightGainData?.currentWeight ?? 0} Kg",
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
                                        "${controller.getPregnancyWeightGainData?.totalGain ?? 0} Kg",
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
                                  final weightData =
                                      controller.weightGainHistory[index];
                                  final isEvenRow = index % 2 == 0;
                                  final rowColor =
                                      isEvenRow ? Colors.pink[50] : null;
                                  final DateTime? parsedDate =
                                      weightData.tanggalPencatatan != null
                                          ? DateTime.tryParse(
                                              weightData.tanggalPencatatan!)
                                          : null;
                                  final formattedDate = parsedDate != null
                                      ? DateFormat('dd.MM').format(parsedDate)
                                      : 'Invalid date';

                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<
                                        Color?>((Set<MaterialState> states) {
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
                                              color: (weightData
                                                              .pertambahanBerat ??
                                                          0) <
                                                      0
                                                  ? Colors.red
                                                  : (weightData.pertambahanBerat ??
                                                              0) ==
                                                          0
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
                                            child: Icon(
                                                Icons.more_vert_outlined,
                                                size: 16),
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Wrap(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 4.h,
                                                            width: 32.w,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 16.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blueGrey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    3.0),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 10.h),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    10, 0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                controller.deleteWeeklyWeightGain(
                                                                    weightData
                                                                            .id ??
                                                                        0);
                                                                Get.back();
                                                                controller
                                                                    .focusNode
                                                                    .unfocus();
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16),
                                                                height: 50,
                                                                width:
                                                                    Get.width,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "Delete Weekly Weight Gain Data",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      Icon(Icons
                                                                          .delete)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height: 10.h),
                                                        ],
                                                      ),
                                                    ],
                                                  );
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
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ));
            }
          },
        ),
      ),
    );
  }
}
