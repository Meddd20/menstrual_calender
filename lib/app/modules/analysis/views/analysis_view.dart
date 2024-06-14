import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/bleeding_flow_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/moods_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/notes_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/others_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/physical_activity_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/sex_activity_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/symptoms_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/temperature_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/vaginal_discharge_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/weight_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/pregnancy_tools_view.dart';
import '../controllers/analysis_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';

class AnalysisView extends GetView {
  const AnalysisView({super.key});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return box.read("isPregnant") == "0"
        ? AnalysisPeriodView()
        : PregnancyToolsView();
  }
}

class AnalysisPeriodView extends GetView<AnalysisController> {
  const AnalysisPeriodView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AnalysisController());
    HomeMenstruationController homeController =
        Get.put(HomeMenstruationController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis'),
          centerTitle: true,
        ),
        body: Padding(
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
                      height: 195.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "My Cycle",
                                  style: CustomTextStyle.heading4TextStyle(),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "See more",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_right)
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "${homeController.data?.actualPeriod.length} cycle history logged",
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 2.0,
                                fontFamily: 'Poppins',
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 100.h,
                                      width: 155,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color(0xFFFFD7DF),
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Average Cycle Length",
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${homeController.data?.avgPeriodCycle}",
                                                    style: TextStyle(
                                                      fontSize: 23.sp,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " days",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 100.h,
                                      width: 155,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // color: Color(0xFFFFE69E),
                                        border: Border.all(
                                          color: Color(0xFFFD9414),
                                          width: 0.5,
                                        ),
                                        color: Color(0xFFFFE69E),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Average Period Length",
                                              style: TextStyle(
                                                color: Color(0xFFFD9414),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        "${homeController.data?.avgPeriodDuration}",
                                                    style: TextStyle(
                                                      fontSize: 23.sp,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " days",
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        height: 515,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(width: 0.5, color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: GridView(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 6,
                            ),
                            children: [
                              CustomIconCard(
                                icon: Icons.bloodtype_outlined,
                                text: "Bleeding Flow",
                                onTap: () => Get.to(() => BleedingFlowView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Sex Activity",
                                onTap: () => Get.to(() => SexActivityView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Symptoms",
                                onTap: () => Get.to(() => SymptomsView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Vaginal Discharge",
                                onTap: () =>
                                    Get.to(() => VaginalDischargeView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Moods",
                                onTap: () => Get.to(() => MoodsView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Others",
                                onTap: () => Get.to(() => OthersView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Physical Activity",
                                onTap: () =>
                                    Get.to(() => PhysicalActivityView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Temperature",
                                onTap: () => Get.to(() => TemperatureView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Weight",
                                onTap: () => Get.to(() => WeightView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Reminder",
                                onTap: () => Get.to(() => ReminderView()),
                              ),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Notes",
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
