import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/temperature_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class TemperatureView extends GetView<TemperatureController> {
  const TemperatureView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TemperatureController());
    final PageController _pageController = PageController();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.temperature,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.totalEntries,
                  style: CustomTextStyle.medium(15, color: Colors.black.withOpacity(0.6)),
                ),
                Obx(
                  () => Text(
                    AppLocalizations.of(context)!.totalEntriesData("${controller.specificTemperaturesData.entries.length}"),
                    style: CustomTextStyle.extraBold(26, height: 1.75),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.selectedDataTags != "pregnancy_temperature" ? AppLocalizations.of(context)!.entriesFromDate(formatDateWithMonthName(controller.selectedDate.value)) : AppLocalizations.of(context)!.fromTheFirstDayOfPregnancy,
                    style: CustomTextStyle.semiBold(16, color: Colors.black.withOpacity(0.6), height: 1.5),
                  ),
                ),
                Container(
                  height: Get.height * 0.375,
                  width: Get.width,
                  child: Obx(
                    () {
                      List<double> values = controller.temperatures.entries.map((entry) => double.parse(entry.value)).toList();
                      double max = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;
                      double min = values.isNotEmpty ? values.reduce((a, b) => a < b ? a : b) : 0;
                      return SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                            final MapEntry<String, dynamic> entry = controller.temperatures.entries.elementAt(pointIndex);

                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.date("${entry.key}"),
                                    style: CustomTextStyle.bold(12, color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    AppLocalizations.of(context)!.temperatureCelcius("${entry.value}"),
                                    style: CustomTextStyle.bold(12, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        primaryXAxis: DateTimeAxis(
                          initialVisibleMinimum: DateTime.now().subtract(Duration(days: 5)),
                          initialVisibleMaximum: DateTime.now(),
                          autoScrollingDelta: 5,
                          autoScrollingMode: AutoScrollingMode.end,
                          autoScrollingDeltaType: DateTimeIntervalType.days,
                          interval: 01,
                          intervalType: DateTimeIntervalType.days,
                          initialZoomPosition: 0.1,
                          enableAutoIntervalOnZooming: true,
                          plotOffset: 34,
                          dateFormat: DateFormat('MMM dd'),
                          labelIntersectAction: AxisLabelIntersectAction.hide,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: min - 1,
                          maximum: max + 0.5,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        series: <CartesianSeries>[
                          ScatterSeries<MapEntry<String, dynamic>, DateTime>(
                            dataSource: controller.temperatures.entries.toList(),
                            xValueMapper: (MapEntry<String, dynamic> entry, _) => DateTime.parse(entry.key),
                            yValueMapper: (MapEntry<String, dynamic> entry, _) => double.parse(entry.value),
                            markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 15,
                              width: 15,
                            ),
                            name: "Temperature",
                          ),
                        ],
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),
                      );
                    },
                  ),
                ),
                if (controller.selectedDataTags != "pregnancy_temperature") ...[
                  CustomTabBar(
                    controller: controller.tabController,
                    onTap: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                      controller.updateTabBar(index);
                    },
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        controller.tabController.animateTo(index);
                        controller.updateTabBar(index);
                      },
                      children: [
                        _buildChart(context),
                        _buildChart(context),
                        _buildChart(context),
                        _buildChart(context),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: PageView(
                      children: [
                        _buildChart(context),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(context) {
    return Obx(
      () {
        if (controller.specificTemperaturesData.entries.length == 0) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.notFoundDesc,
              style: CustomTextStyle.medium(16, color: AppColors.black.withOpacity(0.6), height: 1.5),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: Get.height,
                    child: ListView.builder(
                      itemCount: controller.specificTemperaturesData.entries.length,
                      itemBuilder: (context, index) {
                        final MapEntry<String, dynamic> entry = controller.specificTemperaturesData.entries.elementAt(index);

                        return CustomDateLook(entry: entry, type: "temperature");
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
