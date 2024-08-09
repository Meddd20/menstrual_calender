import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/baby_weight_heigth_tracker_controller.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_tracker_controller.dart';

import '../controllers/pregnancy_tools_controller.dart';

class PregnancyToolsBinding extends Bindings {
  @override
  void dependencies() {
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
