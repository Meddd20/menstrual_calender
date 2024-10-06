import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/baby_weight_heigth_tracker_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/babykicks_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/blood_pressure_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/contraction_timer_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/food_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/pregnancy_log_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/vaccine_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/vitamin_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/weight_tracker_view.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

import '../controllers/pregnancy_tools_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PregnancyToolsView extends GetView<PregnancyToolsController> {
  const PregnancyToolsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isPregnant = StorageService().getIsPregnant();
    final List<Map<String, String>> pregnancyTools = [
      {'name': AppLocalizations.of(context)!.pregnancyLog, 'icon': 'assets/icon/maternity.png'},
      {'name': AppLocalizations.of(context)!.weightGainTracker, 'icon': 'assets/icon/weight-tracker.png'},
      {'name': AppLocalizations.of(context)!.contractionTimer, 'icon': 'assets/icon/stopwatch.png'},
      {'name': AppLocalizations.of(context)!.bloodPressure, 'icon': 'assets/icon/blood-pressure.png'},
      {'name': AppLocalizations.of(context)!.babyKicks, 'icon': 'assets/icon/baby-kick.png'},
      {'name': AppLocalizations.of(context)!.reminder, 'icon': 'assets/icon/alarm.png'},
      {'name': AppLocalizations.of(context)!.fetalDevelopment, 'icon': 'assets/icon/fetal.png'},
      {'name': AppLocalizations.of(context)!.vaccine, 'icon': 'assets/icon/vaccine.png'},
      {'name': AppLocalizations.of(context)!.vitamins, 'icon': 'assets/icon/vitamin.png'},
      {'name': AppLocalizations.of(context)!.food, 'icon': 'assets/icon/nutrition.png'},
    ];

    final List<Map<String, String>> recoveryTools = [
      {'name': AppLocalizations.of(context)!.reminder, 'icon': 'assets/icon/alarm.png'},
      {'name': AppLocalizations.of(context)!.fetalDevelopment, 'icon': 'assets/icon/fetal.png'},
      {'name': AppLocalizations.of(context)!.vaccine, 'icon': 'assets/icon/vaccine.png'},
      {'name': AppLocalizations.of(context)!.vitamins, 'icon': 'assets/icon/vitamin.png'},
      {'name': AppLocalizations.of(context)!.food, 'icon': 'assets/icon/nutrition.png'},
    ];

    final List<Map<String, String>> tools = isPregnant == "1" ? pregnancyTools : recoveryTools;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.pregnancyTools,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return GestureDetector(
                onTap: () {
                  if (isPregnant == "1") {
                    switch (index) {
                      case 0:
                        Get.to(() => PregnancyLogView());
                        break;
                      case 1:
                        Get.to(() => WeightTrackerView());
                        break;
                      case 2:
                        Get.to(() => ContractionTimerView());
                        break;
                      case 3:
                        Get.to(() => BloodPressureView());
                        break;
                      case 4:
                        Get.to(() => BabykicksView());
                        break;
                      case 5:
                        Get.to(() => ReminderView());
                        break;
                      case 6:
                        Get.to(() => BabyWeightHeigthTrackerView());
                        break;
                      case 7:
                        Get.to(() => VaccineListView());
                        break;
                      case 8:
                        Get.to(() => VitaminListView());
                        break;
                      case 9:
                        Get.to(() => FoodListView());
                        break;
                    }
                  } else {
                    switch (index) {
                      case 0:
                        Get.to(() => ReminderView());
                        break;
                      case 1:
                        Get.to(() => BabyWeightHeigthTrackerView());
                        break;
                      case 2:
                        Get.to(() => VaccineListView());
                        break;
                      case 3:
                        Get.to(() => VitaminListView());
                        break;
                      case 4:
                        Get.to(() => FoodListView());
                        break;
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(tool['icon'] ?? "", height: 70, width: 70),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tool['name'] ?? "",
                          style: CustomTextStyle.semiBold(14, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
