import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/contraction_timer_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class ContractionTimerView extends GetView<ContractionTimerController> {
  const ContractionTimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ContractionTimerController());
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
                    AppLocalizations.of(context)!.contractionTimer,
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
                                      AppLocalizations.of(context)!.contractionInfo,
                                      style: CustomTextStyle.extraBold(22, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!.contractionDesc,
                                      style: CustomTextStyle.medium(16, height: 1.75),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!.whyTrackingContractionImportant,
                                      style: CustomTextStyle.extraBold(22, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!.whyTrackingContractionImportantDesc,
                                      style: CustomTextStyle.medium(16, height: 1.75),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      AppLocalizations.of(context)!.twoTypeContraction,
                                      style: CustomTextStyle.extraBold(22, height: 1.5),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      AppLocalizations.of(context)!.twoTypeContractionDesc,
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
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        floatingActionButton: Obx(
          () => Container(
            width: Get.width / 2,
            height: 50,
            child: FloatingActionButton(
              onPressed: controller.isRunning.value ? controller.stop : controller.start,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              backgroundColor: AppColors.highlight,
              child: Icon(
                controller.isRunning.value ? Icons.stop : Icons.play_arrow,
                size: 30,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  width: Get.width,
                  height: 250.h,
                  decoration: ShapeDecoration(shape: CircleBorder(), color: AppColors.highlight),
                  child: Center(
                    child: Text(
                      '${controller.elapsedTime.value.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
                      '${controller.elapsedTime.value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      style: CustomTextStyle.extraBold(50),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.time,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.duration,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.interval,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(child: Center(child: Text(""))),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      controller.allContraction.length,
                      (index) {
                        final contraction = controller.allContraction[index];
                        return DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  formatShortDate(contraction.timeStart),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  formatHourMinuteSecond(contraction.timeStart),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  _formatDuration(contraction.duration),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Text(
                                  _formatDuration(contraction.interval ?? 0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.black.withOpacity(0.4),
                                  onPressed: () => controller.deleteContraction(context, contraction.id!),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 65),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDuration(int totalSeconds) {
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
