import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/baby_weight_heigth_tracker_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BabyWeightHeigthTrackerView extends GetView<BabyWeightHeigthTrackerController> {
  const BabyWeightHeigthTrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BabyWeightHeigthTrackerController());
    final PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            '${controller.selectedDataType.value == "Weight" ? AppLocalizations.of(context)!.fetalWeightDevelopment : AppLocalizations.of(context)!.fetalHeightDevelopment} ',
            style: CustomTextStyle.extraBold(20),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Color(0xFFFefeff0),
              ),
              child: TabBar(
                controller: controller.tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColors.white,
                ),
                dividerColor: AppColors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.all(2),
                labelColor: Colors.black,
                isScrollable: false,
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                  controller.updateTabBar(index);
                },
                unselectedLabelColor: Colors.grey.shade600,
                tabs: [
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.fetalWeight,
                      style: CustomTextStyle.bold(15),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.fetalHeight,
                      style: CustomTextStyle.bold(15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Obx(
              () => Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    controller.tabController.animateTo(index);
                    controller.updateTabBar(index);
                  },
                  children: [
                    _buildChart(controller.babyWeightData, context),
                    _buildChart(controller.babyHeightData, context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(RxList<Map<String, dynamic>> data, context) {
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(
          child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              labelStyle: CustomTextStyle.regular(10),
              title: AxisTitle(
                text: "${controller.selectedDataType.value == "Weight" ? AppLocalizations.of(context)!.weightUnit : AppLocalizations.of(context)!.heightUnit}",
                textStyle: CustomTextStyle.bold(12),
                alignment: ChartAlignment.center,
              ),
              minimum: 0,
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: CustomTextStyle.regular(10),
              title: AxisTitle(
                text: AppLocalizations.of(context)!.weekPregnancy,
                textStyle: CustomTextStyle.bold(12),
              ),
              interval: 1,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                int week = details.value.toInt();
                if ([0, 12, 28, 40].contains(week)) {
                  return ChartAxisLabel('$week', TextStyle(color: Colors.black));
                } else {
                  return ChartAxisLabel('', TextStyle(color: Colors.transparent));
                }
              },
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              lineType: TrackballLineType.vertical,
              tooltipSettings: InteractiveTooltip(
                enable: true,
                format: '${controller.selectedDataType.value == "Weight" ? "#${AppLocalizations.of(context)!.week} point.x \n  point.y gram" : "#${AppLocalizations.of(context)!.week} point.x \n  point.y milimeter"}',
              ),
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.center,
              shouldAlwaysShow: true,
            ),
            series: [
              LineSeries<Map<String, dynamic>, int>(
                dataSource: data,
                xValueMapper: (Map<String, dynamic> entry, _) => entry['week'] as int,
                yValueMapper: (Map<String, dynamic> entry, _) => entry['weight'] ?? entry['height'] as double,
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
      ],
    );
  }
}
