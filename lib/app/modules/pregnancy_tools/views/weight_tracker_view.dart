import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_expanded_calendar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_tracker_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/init_weight_gain_tracker_view.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeightTrackerView extends GetView<WeightTrackerController> {
  const WeightTrackerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(WeightTrackerController());
    return FutureBuilder<void>(
      future: controller.weightGainIndexData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return (controller.weightGainHistory.length < 1) ? InitWeightGainTrackerView() : WeightGainTrackerView();
        }
      },
    );
  }
}

class WeightGainTrackerView extends GetView<WeightTrackerController> {
  const WeightGainTrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WeightTrackerController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.weightGainTracker,
                    style: CustomTextStyle.extraBold(20),
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
                                      AppLocalizations.of(context)!.weightChanges,
                                      style: CustomTextStyle.extraBold(22, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!.weightChangesDesc,
                                      style: CustomTextStyle.medium(16, height: 1.75),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!.recommendWeightInfoTitle,
                                      style: CustomTextStyle.extraBold(22, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!.recommendWeightInfo,
                                      style: CustomTextStyle.semiBold(16, height: 1.75),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      AppLocalizations.of(context)!.recommendWeightInfoDesc,
                                      style: CustomTextStyle.medium(16, height: 1.75),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!.whyWeightGainImportant,
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/navigation-menu'));
            },
          ),
        ),
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
                                      AppLocalizations.of(context)!.addNewWeight,
                                      style: CustomTextStyle.extraBold(20, height: 1.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      controller.resetValue();
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
                                    controller.getSelectedWeek(selectedDay);
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
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.selectedDate,
                                      style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Text(
                                      "${formatDate(controller.selectedDate ?? DateTime.now())}",
                                      style: CustomTextStyle.bold(16),
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
                                      AppLocalizations.of(context)!.pregnancyWeek,
                                      style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.week} ${controller.selectedWeek}",
                                      style: CustomTextStyle.bold(16),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  NumberPicker(
                                    minValue: 30,
                                    maxValue: 150,
                                    value: controller.selectedWeight,
                                    onChanged: controller.setSelectedWeight,
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
                                  Text(
                                    ".",
                                    style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                  ),
                                  NumberPicker(
                                    minValue: 0,
                                    maxValue: 9,
                                    value: controller.selectedWeightDecimal,
                                    onChanged: controller.setSelectedWeightDecimal,
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
                                  SizedBox(width: 10),
                                  Text(
                                    "Kg",
                                    style: CustomTextStyle.extraBold(20, color: AppColors.primary),
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
                              text: AppLocalizations.of(context)!.save,
                              onPressed: () => controller.weeklyWeightGain(context),
                            ),
                          )
                        ],
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
                                trackballArgs.chartPointInfo.label = '${AppLocalizations.of(context)!.recommendWeek} \n ${AppLocalizations.of(context)!.week} ${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].week} \n  ${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].recommendWeightLower} - ${controller.reccomendWeightGain[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].recommendWeightUpper} kg';
                              } else {
                                trackballArgs.chartPointInfo.label = '${AppLocalizations.of(context)!.week} ${controller.weightGainHistory[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].mingguKehamilan} \n ${controller.weightGainHistory[(trackballArgs.chartPointInfo.dataPointIndex)!.toInt()].beratBadan} kg';
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
                                text: AppLocalizations.of(context)!.weeksOfPregnancy,
                                textStyle: CustomTextStyle.bold(12),
                              ),
                              majorTickLines: MajorTickLines(size: 0),
                              majorGridLines: MajorGridLines(width: 0),
                              labelFormat: '{value}' + "",
                              labelStyle: CustomTextStyle.medium(10),
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
                              maximum: controller.reccomendWeightGain.isNotEmpty ? controller.reccomendWeightGain.map((data) => data.recommendWeightUpper!).reduce((value, element) => value > element ? value : element) + 1 : 0,
                              labelStyle: CustomTextStyle.medium(10),
                              title: AxisTitle(
                                text: AppLocalizations.of(context)!.weightGainUnit,
                                textStyle: CustomTextStyle.bold(12),
                              ),
                            ),
                            series: [
                              RangeAreaSeries<RecommendWeightGain, int>(
                                dataSource: controller.reccomendWeightGain,
                                name: AppLocalizations.of(context)!.recommendedWeightGainRange,
                                xValueMapper: (RecommendWeightGain data, _) => data.week!,
                                highValueMapper: (RecommendWeightGain data, _) => data.recommendWeightUpper!,
                                lowValueMapper: (RecommendWeightGain data, _) => data.recommendWeightLower!,
                                markerSettings: MarkerSettings(),
                                color: AppColors.highlight,
                              ),
                              LineSeries<WeightHistory, int>(
                                dataSource: controller.weightGainHistory,
                                name: AppLocalizations.of(context)!.actualWeightGain,
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
                                      style: CustomTextStyle.extraBold(18, height: 1.5),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.starting,
                                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${(controller.getPregnancyWeightGainData?.currentWeight ?? 0).toStringAsFixed(1)} Kg",
                                      style: CustomTextStyle.extraBold(18, height: 1.5),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.current,
                                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${(controller.getPregnancyWeightGainData?.totalGain ?? 0).toStringAsFixed(1)} Kg",
                                      style: CustomTextStyle.extraBold(18, height: 1.5),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.totalGain,
                                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
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
                                  AppLocalizations.of(context)!.recommendedWeightGain,
                                  style: CustomTextStyle.extraBold(18, height: 1.5),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "${controller.getPregnancyWeightGainData?.currentWeekReccomendWeight ?? ""} Kg",
                                          style: CustomTextStyle.extraBold(18, height: 1.5),
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.currentWeek} \n(${AppLocalizations.of(context)!.week} ${controller.getPregnancyWeightGainData?.week ?? 0})",
                                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${controller.getPregnancyWeightGainData?.nextWeekReccomendWeight ?? 0} Kg",
                                          style: CustomTextStyle.extraBold(18, height: 1.5),
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.nextWeek} \n(${AppLocalizations.of(context)!.week} ${(controller.getPregnancyWeightGainData?.week ?? 0) + 1})",
                                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
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
                            AppLocalizations.of(context)!.previousRecord,
                            style: CustomTextStyle.extraBold(20, height: 1.5),
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
                            headingTextStyle: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                            dataTextStyle: CustomTextStyle.semiBold(14, height: 1.5),
                            columns: [
                              DataColumn(
                                label: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.weight,
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
                                      AppLocalizations.of(context)!.dates,
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
                                      AppLocalizations.of(context)!.week,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.gain,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
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
                                final formattedDate = parsedDate != null ? formatShortDate(parsedDate.toString()) : 'Invalid date';
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
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          formattedDate,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          '${weightData.mingguKehamilan}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          '${weightData.pertambahanBerat?.toStringAsFixed(1) ?? "0"} kg',
                                          style: CustomTextStyle.semiBold(14,
                                              height: 1.5,
                                              color: (weightData.pertambahanBerat ?? 0) < 0
                                                  ? Colors.red
                                                  : (weightData.pertambahanBerat ?? 0) == 0
                                                      ? Colors.black
                                                      : Colors.green),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: GestureDetector(
                                          child: Icon(
                                            Icons.more_vert_outlined,
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Obx(() => Wrap(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              InkWell(
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
                                                                                              AppLocalizations.of(context)!.editWeight,
                                                                                              style: CustomTextStyle.extraBold(20, height: 1.5),
                                                                                              textAlign: TextAlign.center,
                                                                                            ),
                                                                                          ),
                                                                                          IconButton(
                                                                                            icon: Icon(Icons.close),
                                                                                            onPressed: () {
                                                                                              controller.resetValue();
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
                                                                                          onDaySelected: (selectedDay, focusedDay) {},
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
                                                                                      SizedBox(height: 10),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              AppLocalizations.of(context)!.selectedDate,
                                                                                              style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                                                                            ),
                                                                                            Text(
                                                                                              "${formatDate(controller.selectedDate ?? DateTime.now())}",
                                                                                              style: CustomTextStyle.bold(16),
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
                                                                                                  AppLocalizations.of(context)!.pregnancyWeek,
                                                                                                  style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5)),
                                                                                                ),
                                                                                                Text(
                                                                                                  "${controller.selectedWeek}",
                                                                                                  style: CustomTextStyle.bold(16),
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
                                                                                            value: controller.selectedWeight,
                                                                                            onChanged: controller.setSelectedWeight,
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
                                                                                          Text(
                                                                                            ".",
                                                                                            style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                                                          ),
                                                                                          NumberPicker(
                                                                                            minValue: 0,
                                                                                            maxValue: 9,
                                                                                            value: controller.selectedWeightDecimal,
                                                                                            onChanged: controller.setSelectedWeightDecimal,
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
                                                                                          SizedBox(width: 10),
                                                                                          Text(
                                                                                            "Kg",
                                                                                            style: CustomTextStyle.extraBold(20, color: AppColors.primary),
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
                                                                                      text: AppLocalizations.of(context)!.save,
                                                                                      onPressed: () => controller.weeklyWeightGain(context),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }).then((value) {
                                                                      Get.off(WeightGainTrackerView());
                                                                      controller.resetValue();
                                                                    });
                                                                  else {
                                                                    Get.to(() => InitWeightGainTrackerView(isTwin: controller.getPregnancyWeightGainData?.isTwin));
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
                                                                          AppLocalizations.of(context)!.editWeightData,
                                                                          style: CustomTextStyle.bold(14),
                                                                        ),
                                                                        Icon(Icons.edit)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (index != controller.weightGainHistory.length - 1) ...[
                                                                InkWell(
                                                                  onTap: () {
                                                                    controller.deleteWeeklyWeightGain(DateTime.parse(weightData.tanggalPencatatan!), context);
                                                                    controller.focusNode.unfocus();
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
                                                                            AppLocalizations.of(context)!.deleteWeightData,
                                                                            style: CustomTextStyle.bold(14),
                                                                          ),
                                                                          Icon(Icons.delete),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                            ],
                                                          ),
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
