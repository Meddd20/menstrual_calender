import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_card.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/logs_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/notes_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/temperature_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/weight_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/pregnancy_tools_view.dart';
import '../controllers/analysis_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalysisView extends GetView {
  const AnalysisView({super.key});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return box.read("isPregnant") == "0" ? AnalysisPeriodView() : PregnancyToolsView();
  }
}

class AnalysisPeriodView extends GetView<AnalysisController> {
  const AnalysisPeriodView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AnalysisController());
    HomeMenstruationController homeController = Get.put(HomeMenstruationController());
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.periodAnalysis,
            style: CustomTextStyle.extraBold(22),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Align(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PeriodCycleView());
                    },
                    child: Container(
                      width: Get.width,
                      height: 205.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.myCycle,
                                  style: CustomTextStyle.extraBold(18),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.seeMore,
                                      style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.6)),
                                    ),
                                    Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              AppLocalizations.of(context)!.periodCycleLogged("${homeController.data?.actualPeriod?.length}"),
                              style: CustomTextStyle.medium(14, height: 2.0, color: Colors.black.withOpacity(0.6)),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xFFFFD7DF),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.averageCycleLength,
                                            style: CustomTextStyle.extraBold(15, color: AppColors.primary),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${homeController.data?.avgPeriodCycle}",
                                                  style: CustomTextStyle.extraBold(23),
                                                ),
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.daysPrefix,
                                                  style: CustomTextStyle.semiBold(14),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color(0xFFFD9414),
                                        width: 0.5,
                                      ),
                                      color: Color(0xFFFFE69E),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.averagePeriodLength,
                                            style: CustomTextStyle.extraBold(15, color: Color(0xFFFD9414)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${homeController.data?.avgPeriodDuration}",
                                                  style: CustomTextStyle.extraBold(23),
                                                ),
                                                TextSpan(
                                                  text: AppLocalizations.of(context)!.daysPrefix,
                                                  style: CustomTextStyle.semiBold(14),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Column(
                            //       children: [
                            //         Container(
                            //           height: 110.h,
                            //           width: 155,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(12),
                            //             color: Color(0xFFFFD7DF),
                            //             border: Border.all(
                            //               color: AppColors.primary,
                            //               width: 0.5,
                            //             ),
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(16.0),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               children: [
                            //                 Text(
                            //                   AppLocalizations.of(context)!.averageCycleLength,
                            //                   style: CustomTextStyle.extraBold(15, color: AppColors.primary),
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                 ),
                            //                 SizedBox(height: 5),
                            //                 RichText(
                            //                   text: TextSpan(
                            //                     children: [
                            //                       TextSpan(
                            //                         text: "${homeController.data?.avgPeriodCycle}",
                            //                         style: CustomTextStyle.extraBold(23),
                            //                       ),
                            //                       TextSpan(
                            //                         text: AppLocalizations.of(context)!.daysPrefix,
                            //                         style: CustomTextStyle.semiBold(14),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         Container(
                            //           height: 110.h,
                            //           width: 155,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(12),
                            //             border: Border.all(
                            //               color: Color(0xFFFD9414),
                            //               width: 0.5,
                            //             ),
                            //             color: Color(0xFFFFE69E),
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(16.0),
                            //             child: Column(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               crossAxisAlignment: CrossAxisAlignment.center,
                            //               children: [
                            //                 Text(
                            //                   AppLocalizations.of(context)!.averagePeriodLength,
                            //                   style: CustomTextStyle.extraBold(15, color: Color(0xFFFD9414)),
                            //                   maxLines: 2,
                            //                   overflow: TextOverflow.ellipsis,
                            //                 ),
                            //                 SizedBox(height: 5),
                            //                 RichText(
                            //                   text: TextSpan(
                            //                     children: [
                            //                       TextSpan(
                            //                         text: "${homeController.data?.avgPeriodDuration}",
                            //                         style: CustomTextStyle.extraBold(23),
                            //                       ),
                            //                       TextSpan(
                            //                         text: AppLocalizations.of(context)!.daysPrefix,
                            //                         style: CustomTextStyle.semiBold(14),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        height: 515,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: GridView(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 6,
                            ),
                            children: [
                              CustomCircularCard(
                                iconPath: 'assets/icon/bleed.png',
                                text: AppLocalizations.of(context)!.bleedingFlow,
                                onTap: () => Get.to(() => LogsView(), arguments: "bleeding_flow"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/sex.png',
                                text: AppLocalizations.of(context)!.sexActivity,
                                onTap: () => Get.to(() => LogsView(), arguments: "sex_activity"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/acne.png',
                                text: AppLocalizations.of(context)!.symptoms,
                                onTap: () => Get.to(() => LogsView(), arguments: "symptoms"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/raining.png',
                                text: AppLocalizations.of(context)!.vaginalDischarge,
                                onTap: () => Get.to(() => LogsView(), arguments: "vaginal_discharge"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/mood-changes.png',
                                text: AppLocalizations.of(context)!.moods,
                                onTap: () => Get.to(() => LogsView(), arguments: "moods"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/passport.png',
                                text: AppLocalizations.of(context)!.others,
                                onTap: () => Get.to(() => LogsView(), arguments: "others"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/yoga.png',
                                text: AppLocalizations.of(context)!.physicalActivity,
                                onTap: () => Get.to(() => LogsView(), arguments: "physical_activity"),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/temperature.png',
                                text: AppLocalizations.of(context)!.temperature,
                                onTap: () => Get.to(() => TemperatureView()),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/weighing-machine.png',
                                text: AppLocalizations.of(context)!.weight,
                                onTap: () => Get.to(() => WeightView()),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/alarm.png',
                                text: AppLocalizations.of(context)!.reminder,
                                onTap: () => Get.to(() => ReminderView()),
                              ),
                              CustomCircularCard(
                                iconPath: 'assets/icon/notes.png',
                                text: AppLocalizations.of(context)!.notes,
                                onTap: () => Get.to(() => NotesView()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
