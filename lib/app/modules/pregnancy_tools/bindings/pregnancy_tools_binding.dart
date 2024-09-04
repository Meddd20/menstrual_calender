import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/baby_weight_heigth_tracker_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/babykicks_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/blood_pressure_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/contraction_timer_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/food_list_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/pregnancy_log_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/vaccine_list_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/vitamin_list_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_tracker_controller.dart';

import '../controllers/pregnancy_tools_controller.dart';

class PregnancyToolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractionTimerController>(
      () => ContractionTimerController(),
    );
    Get.lazyPut<BloodPressureController>(
      () => BloodPressureController(),
    );
    Get.lazyPut<BabykicksController>(
      () => BabykicksController(),
    );
    Get.lazyPut<PregnancyLogController>(
      () => PregnancyLogController(),
    );
    Get.lazyPut<FoodListController>(
      () => FoodListController(),
    );
    Get.lazyPut<FoodListController>(
      () => FoodListController(),
    );
    Get.lazyPut<VitaminListController>(
      () => VitaminListController(),
    );
    Get.lazyPut<VaccineListController>(
      () => VaccineListController(),
    );
    Get.lazyPut<WeightTrackerController>(
      () => WeightTrackerController(),
    );
    Get.lazyPut<BabyWeightHeigthTrackerController>(
      () => BabyWeightHeigthTrackerController(),
    );
    Get.lazyPut<PregnancyToolsController>(
      () => PregnancyToolsController(),
    );
  }
}
