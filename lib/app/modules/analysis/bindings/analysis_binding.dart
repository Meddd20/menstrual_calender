import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/analysis/controllers/logs_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/notes_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/temperature_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/weight_controller.dart';

import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeriodCycleController>(
      () => PeriodCycleController(),
    );
    Get.lazyPut<LogsController>(
      () => LogsController(),
    );
    Get.lazyPut<NotesController>(
      () => NotesController(),
    );
    Get.lazyPut<WeightController>(
      () => WeightController(),
    );
    Get.lazyPut<TemperatureController>(
      () => TemperatureController(),
    );
    Get.lazyPut<PeriodCycleController>(
      () => PeriodCycleController(),
    );
    Get.lazyPut<AnalysisController>(
      () => AnalysisController(),
    );
  }
}
