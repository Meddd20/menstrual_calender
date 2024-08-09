import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_add_period_bottom_sheet.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PeriodCycleView extends GetView<PeriodCycleController> {
  final int initialIndex;
  const PeriodCycleView({Key? key, this.initialIndex = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(PeriodCycleController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Cycle'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print({'initialIndex': initialIndex});
            Get.offAllNamed(
              Routes.NAVIGATION_MENU,
              arguments: {'initialIndex': initialIndex},
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        tooltip: 'Add Period Cycle',
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    Obx(
                      () {
                        return AddPeriodBottomSheetWidget(
                          closeModalBottomSheet: () {
                            controller.cancelEdit();
                            Get.back();
                          },
                          title: "Add Period Cycle",
                          buttonCaption: "Add Period",
                          startDate: Obx(
                            () => Text(
                              "${DateFormat('yyyy-MM-dd').format(controller.startDate.value ?? DateTime.now())}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          endDate: Obx(
                            () => Text(
                              "${DateFormat('yyyy-MM-dd').format(controller.endDate.value ?? DateTime.now())}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          addPeriodOnPressedButton: () {
                            controller.addPeriod(controller.periodCycleData.first.avgPeriodDuration ?? 8, controller.periodCycleData.first.avgPeriodCycle ?? 28, context);
                          },
                          calenderValue: [controller.startDate.value, controller.endDate.value],
                          calenderOnValueChanged: (dates) {
                            if (dates.first != null) {
                              controller.setStartDate(dates.first);

                              final avgPeriodDuration = controller.periodCycleData.first.avgPeriodDuration ?? 8;

                              if (dates.last != null) {
                                controller.setEndDate(dates.last);
                              } else {
                                final lastDate = dates.first!.add(Duration(days: avgPeriodDuration));

                                controller.setEndDate(lastDate);
                              }

                              controller.update();
                            }
                          },
                        );
                      },
                    )
                  ],
                );
              }).then((value) {
            controller.cancelEdit();
          });
        },
      ),
      body: Obx(() {
        var periodHistoryList = controller.periodCycleData.isEmpty ? null : controller.periodCycleData.first;
        if (controller.periodCycleData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: Get.height * 0.4,
                automaticallyImplyLeading: false,
                title: Container(
                  height: Get.height * 0.4,
                  child: Column(
                    children: [
                      SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          format: 'point.x\nDuration: point.y days',
                        ),
                        enableSideBySideSeriesPlacement: false,
                        primaryXAxis: CategoryAxis(
                          interval: 1,
                          initialVisibleMaximum: 7,
                          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        series: <CartesianSeries>[
                          StackedColumnSeries<PeriodChart, String>(
                            dataSource: periodHistoryList?.periodChart ?? [],
                            xValueMapper: (PeriodChart data, _) => '${DateFormat('MMM dd').format(DateTime.parse('${data.startDate}'))} - ${DateFormat('MMM dd').format(DateTime.parse('${data.endDate}').add(Duration(days: data.periodCycle!)))}',
                            yValueMapper: (PeriodChart data, _) => data.periodDuration?.toDouble() ?? 0.0,
                            name: 'Period Duration',
                            color: AppColors.primary,
                          ),
                          StackedColumnSeries<PeriodChart, String>(
                            dataSource: periodHistoryList?.periodChart ?? [],
                            xValueMapper: (PeriodChart data, _) => '${DateFormat('MMM dd').format(DateTime.parse('${data.startDate}'))} - ${DateFormat('MMM dd').format(DateTime.parse('${data.endDate}').add(Duration(days: data.periodCycle!)))}',
                            yValueMapper: (PeriodChart data, _) => (data.periodCycle?.toDouble() ?? 0.0),
                            name: 'Period Cycle',
                            color: AppColors.highlight,
                          ),
                        ],
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: CustomTextStyle.headerCalenderTextStyle(),
                  tabs: [
                    Tab(text: "Actual Periods"),
                    Tab(text: "Prediction Periods"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Center(
                    child: ListView.builder(
                      itemCount: periodHistoryList?.actualPeriod.length ?? 0,
                      itemBuilder: (context, index) {
                        var actualPeriodHistory = periodHistoryList?.actualPeriod[index];
                        var periodHistory = periodHistoryList;

                        DateTime? haidAwalDate = actualPeriodHistory?.haidAwal;
                        int? lamaSiklus = actualPeriodHistory?.lamaSiklus;
                        int? avgPeriodCycle = periodHistory?.avgPeriodCycle;
                        DateTime now = DateTime.now();
                        DateTime? predictEndDate = haidAwalDate?.add(Duration(days: avgPeriodCycle ?? 0));
                        double max = (lamaSiklus != null && lamaSiklus != 0)
                            ? lamaSiklus.toDouble()
                            : (predictEndDate != null && predictEndDate.isBefore(now))
                                ? haidAwalDate!.difference(now).inDays.toDouble().abs()
                                : avgPeriodCycle!.toDouble();

                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Wrap(
                                    children: [
                                      AddPeriodBottomSheetWidget(
                                        closeModalBottomSheet: () {
                                          controller.cancelEdit();
                                          Get.back();
                                        },
                                        title: "Edit Period Cycle",
                                        buttonCaption: "Edit Period",
                                        startDate: Obx(
                                          () => Text(
                                            "${DateFormat('yyyy-MM-dd').format(controller.startDate.value!)}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        endDate: Obx(
                                          () => Text(
                                            "${DateFormat('yyyy-MM-dd').format(controller.endDate.value!)}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        addPeriodOnPressedButton: () {
                                          if (actualPeriodHistory?.id != null) {
                                            controller.editPeriod(context, actualPeriodHistory!.id!, actualPeriodHistory.remoteId!, periodHistory?.avgPeriodCycle ?? 28, periodHistoryList!.avgPeriodDuration!);
                                          }
                                        },
                                        calenderValue: [
                                          DateTime.parse('${actualPeriodHistory?.haidAwal}'),
                                          DateTime.parse('${actualPeriodHistory?.haidAkhir}'),
                                        ],
                                        calenderOnValueChanged: (dates) {
                                          controller.setStartDate(dates.first);
                                          controller.setEndDate(dates.last);
                                          controller.update();
                                        },
                                        isEdit: true,
                                      )
                                    ],
                                  );
                                }).then((value) {
                              controller.cancelEdit();
                            });
                            controller.setStartDate(DateTime.parse('${actualPeriodHistory?.haidAwal}'));
                            controller.setEndDate(DateTime.parse('${actualPeriodHistory?.haidAkhir}'));
                            controller.update();
                          },
                          child: ListTile(
                            title: Text(
                              '${actualPeriodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${actualPeriodHistory.haidAwal}')) : "N/A"} - ${actualPeriodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${actualPeriodHistory.haidAkhir}')) : "N/A"}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 22,
                                  child: DChartSingleBar(
                                    foregroundColor: Color(0xFFFD6666),
                                    value: actualPeriodHistory?.durasiHaid?.toDouble() ?? 0.0,
                                    max: max,
                                    backgroundLabel: Text(
                                      "${(actualPeriodHistory?.lamaSiklus == null || actualPeriodHistory?.lamaSiklus == 0) ? max.toInt() : actualPeriodHistory?.lamaSiklus} days",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    backgroundLabelAlign: Alignment.centerRight,
                                    backgroundLabelPadding: EdgeInsets.only(right: 10.0),
                                    foregroundLabel: Text(
                                      "${actualPeriodHistory?.durasiHaid ?? 0} days",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    foregroundLabelAlign: Alignment.centerLeft,
                                    foregroundLabelPadding: EdgeInsets.only(left: 10.0),
                                    radius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ListView.builder(
                      itemCount: periodHistoryList?.predictionPeriod.length ?? 0,
                      itemBuilder: (context, index) {
                        var periodHistory = periodHistoryList?.predictionPeriod[index];
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${periodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${periodHistory.haidAwal}')) : "N/A"} - ${periodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${periodHistory.haidAkhir}')) : "N/A"}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width,
                                height: 22,
                                child: DChartSingleBar(
                                  foregroundColor: Color(0xFFFD6666),
                                  value: periodHistory?.durasiHaid?.toDouble() ?? 0.0,
                                  max: periodHistory?.lamaSiklus?.toDouble() ?? 0.0,
                                  backgroundLabel: Text(
                                    "${periodHistory?.lamaSiklus ?? 0} days",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  backgroundLabelAlign: Alignment.centerRight,
                                  backgroundLabelPadding: EdgeInsets.only(right: 10.0),
                                  foregroundLabel: Text(
                                    "${periodHistory?.durasiHaid ?? 0} days",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  foregroundLabelAlign: Alignment.centerLeft,
                                  foregroundLabelPadding: EdgeInsets.only(left: 10.0),
                                  radius: BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
