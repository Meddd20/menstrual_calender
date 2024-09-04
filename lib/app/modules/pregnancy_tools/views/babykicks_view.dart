import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/babykicks_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class BabykicksView extends GetView<BabykicksController> {
  const BabykicksView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BabykicksController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.babyKicks,
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
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              InkWell(
                onTap: () => controller.addKickCounter(context),
                customBorder: CircleBorder(),
                child: Ink(
                  width: Get.width,
                  height: 250.h,
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: AppColors.highlight,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icon/foot-print.png',
                      height: 100,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: controller.allKicks.isNotEmpty
                    ? Container(
                        width: Get.width,
                        height: 100,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.dates,
                                      style: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  controller.isLastDateIsInWithin2Hours(controller.allKicks.last.datetimeStart) ?? formatShortDate(controller.allKicks.last.datetimeStart),
                                  style: CustomTextStyle.semiBold(14, height: 1.5),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.firstKick,
                                  style: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  controller.isLastDateIsInWithin2Hours(controller.allKicks.last.datetimeStart) ?? formatHourMinuteSecond(controller.allKicks.first.datetimeStart),
                                  style: CustomTextStyle.semiBold(14, height: 1.5),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.lastKick,
                                  style: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  controller.isLastDateIsInWithin2Hours(controller.allKicks.last.datetimeStart) ?? formatHourMinuteSecond(controller.allKicks.first.datetimeEnd),
                                  style: CustomTextStyle.semiBold(14, height: 1.5),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.kickCount,
                                  style: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  controller.isLastDateIsInWithin2Hours(controller.allKicks.last.datetimeStart) ?? controller.allKicks.first.totalKicks.toString(),
                                  style: CustomTextStyle.semiBold(14, height: 1.5),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          AppLocalizations.of(context)!.noKicksRecordedYet,
                          style: CustomTextStyle.semiBold(14, height: 1.5),
                        ),
                      ),
              ),
              SizedBox(height: 15),
              Container(
                width: Get.width,
                child: DataTable(
                  columnSpacing: 20.0,
                  dataRowMinHeight: 50.0,
                  dataRowMaxHeight: 60.0,
                  dividerThickness: 0,
                  sortAscending: true,
                  headingTextStyle: CustomTextStyle.medium(13, height: 1.5, color: Colors.black.withOpacity(0.6)),
                  dataTextStyle: CustomTextStyle.semiBold(14, height: 1.5),
                  columns: [
                    DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.dates,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.firstKick,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.lastKick,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.kicksCount,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(child: Center(child: Text(""))),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    controller.allKicks.length,
                    (index) {
                      final kick = controller.allKicks[index];
                      return DataRow(cells: [
                        DataCell(
                          Center(
                            child: Text(
                              formatShortDate(kick.datetimeStart),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              formatHourMinuteSecond(kick.datetimeStart),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              formatHourMinuteSecond(kick.datetimeEnd),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              kick.totalKicks.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.black.withOpacity(0.4),
                              onPressed: () => controller.deleteKickCounter(context, kick.id!),
                            ),
                          ),
                        ),
                      ]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
