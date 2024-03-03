import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';

import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeriodCycleController>(
      () => PeriodCycleController(),
    );
    Get.lazyPut<AnalysisController>(
      () => AnalysisController(),
    );
  }
}
