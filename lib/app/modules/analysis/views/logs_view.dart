import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_date_look.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_doughnut_chart.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_tabbar.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/logs_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(LogsController());
    final PageController _pageController = PageController();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              controller.selectedDataTags != "pregnancy_symptoms" ? controller.pageTags(context) : "Pregnancy Symptoms",
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
              if (controller.selectedDataTags != "pregnancy_symptoms")
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(context) {
    return Obx(
      () {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.totalEntries,
                style: CustomTextStyle.medium(15, color: Colors.black.withOpacity(0.6)),
              ),
              Text(
                AppLocalizations.of(context)!.totalEntriesData("${controller.specificLogsData.length}"),
                style: CustomTextStyle.extraBold(26, height: 1.75),
              ),
              Text(
                controller.selectedDataTags != "pregnancy_symptoms" ? AppLocalizations.of(context)!.entriesFromDate("${formatDateWithMonthName(controller.selectedDate.value)}") : AppLocalizations.of(context)!.fromTheFirstDayOfPregnancy,
                style: CustomTextStyle.semiBold(16, color: Colors.black.withOpacity(0.6), height: 1.5),
              ),
              CustomDougnutChart(
                dataSource: controller.getSelectedDataSource(),
                pointColorMapper: (dynamic point, int index) {
                  if (point is MapEntry<String, dynamic>) {
                    return colorPalette[index % colorPalette.length];
                  }
                  return Colors.transparent;
                },
                colorPalette: colorPalette,
              ),
              Expanded(
                child: Container(
                  height: Get.height,
                  child: Obx(() {
                    if (controller.specificLogsData.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.notFoundDesc,
                          style: CustomTextStyle.medium(16, color: AppColors.black.withOpacity(0.6), height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: controller.specificLogsData.length,
                        itemBuilder: (context, index) {
                          final MapEntry<String, dynamic> entry = controller.specificLogsData.entries.elementAt(index);

                          return CustomDateLook(entry: entry, type: "logs");
                        },
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
