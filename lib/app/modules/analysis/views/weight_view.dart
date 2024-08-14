import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_date_look.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_tabbar.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/weight_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightView extends GetView<WeightController> {
  const WeightView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WeightController());
    final PageController _pageController = PageController();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Weight",
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Total Entries",
                style: CustomTextStyle.medium(15, color: Colors.black.withOpacity(0.6)),
              ),
              Obx(
                () => Text(
                  "${controller.specificWeightData.entries.length} Entries",
                  style: CustomTextStyle.extraBold(26, height: 1.75),
                ),
              ),
              Obx(
                () => Text(
                  "from ${controller.formatDate(controller.selectedDate.value)} up to today",
                  style: CustomTextStyle.semiBold(16, color: Colors.black.withOpacity(0.6), height: 1.5),
                ),
              ),
              Container(
                height: Get.height * 0.375,
                width: Get.width,
                child: Obx(
                  () {
                    if (controller.weight.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<double> values = controller.weight.entries.map((entry) => double.parse(entry.value)).toList();
                      double max = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;
                      double min = values.isNotEmpty ? values.reduce((a, b) => a < b ? a : b) : 0;
                      return SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                          builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                            final MapEntry<String, dynamic> entry = controller.weight.entries.elementAt(pointIndex);

                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Date: ${entry.key}',
                                    style: CustomTextStyle.bold(12, color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Temperature: ${entry.value} °C',
                                    style: CustomTextStyle.bold(12, color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        primaryXAxis: DateTimeAxis(
                          interval: 1,
                          initialVisibleMinimum: DateTime.now().subtract(Duration(days: 5)),
                          initialVisibleMaximum: DateTime.now(),
                          edgeLabelPlacement: EdgeLabelPlacement.none,
                          plotOffset: 34,
                          dateFormat: DateFormat('MMM dd'),
                          labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: min - 1,
                          maximum: max + 0.5,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                        ),
                        series: <CartesianSeries>[
                          LineSeries<MapEntry<String, dynamic>, DateTime>(
                            dataSource: controller.weight.entries.toList(),
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
                      itemCount: controller.specificWeightData.entries.length,
                      itemBuilder: (context, index) {
                        final MapEntry<String, dynamic> entry = controller.specificWeightData.entries.elementAt(index);

                        return CustomDateLook(entry: entry, type: "weight");
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
