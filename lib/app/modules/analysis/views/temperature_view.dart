import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/temperature_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
          title: const Text('Temperature'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Total Entries",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(
                () => Text(
                  "${controller.specificTemperaturesData.entries.length} Entries",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                "from ${controller.formatDate(controller.selectedDate.value)} up to today",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 15,
                  height: 2.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                height: Get.height * 0.375,
                width: Get.width,
                child: Obx(
                  () {
                    if (controller.temperatures.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<double> values = controller.temperatures.entries
                          .map((entry) => double.parse(entry.value))
                          .toList();
                      double max = values.isNotEmpty
                          ? values.reduce((a, b) => a > b ? a : b)
                          : 0;
                      double min = values.isNotEmpty
                          ? values.reduce((a, b) => a < b ? a : b)
                          : 0;
                      return SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          builder: (dynamic data, dynamic point, dynamic series,
                              int pointIndex, int seriesIndex) {
                            final MapEntry<String, dynamic> entry = controller
                                .temperatures.entries
                                .elementAt(pointIndex);

                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Date: ${entry.key}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Temperature: ${entry.value} °C',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            );
                          },
                        ),
                        primaryXAxis: DateTimeAxis(
                          interval: 1,
                          initialVisibleMinimum:
                              DateTime.now().subtract(Duration(days: 5)),
                          initialVisibleMaximum: DateTime.now(),
                          edgeLabelPlacement: EdgeLabelPlacement.none,
                          plotOffset: 34,
                          dateFormat: DateFormat('MMM dd'),
                          labelIntersectAction:
                              AxisLabelIntersectAction.multipleRows,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: min - 1,
                          maximum: max + 0.5,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        series: <CartesianSeries>[
                          ScatterSeries<MapEntry<String, dynamic>, DateTime>(
                            dataSource:
                                controller.temperatures.entries.toList(),
                            xValueMapper:
                                (MapEntry<String, dynamic> entry, _) =>
                                    DateTime.parse(entry.key),
                            yValueMapper:
                                (MapEntry<String, dynamic> entry, _) =>
                                    double.parse(entry.value),
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
                    }
                  },
                ),
              ),
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
                    _buildChart(),
                    _buildChart(),
                    _buildChart(),
                    _buildChart(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Obx(
      () {
        if (controller.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: Get.height,
                    child: ListView.builder(
                      itemCount:
                          controller.specificTemperaturesData.entries.length,
                      itemBuilder: (context, index) {
                        final MapEntry<String, dynamic> entry = controller
                            .specificTemperaturesData.entries
                            .elementAt(index);

                        return CustomDateLook(entry: entry);
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
