import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/analysis/controllers/bleeding_flow_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/moods_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/notes_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/others_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/physical_activity_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/sex_activity_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/symptoms_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/temperature_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/vaginal_discharge_controller.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/weight_controller.dart';

import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OthersController>(
      () => OthersController(),
    );
    Get.lazyPut<BleedingFlowController>(
      () => BleedingFlowController(),
    );
    Get.lazyPut<SymptomsController>(
      () => SymptomsController(),
    );
    Get.lazyPut<VaginalDischargeController>(
      () => VaginalDischargeController(),
    );
    Get.lazyPut<MoodsController>(
      () => MoodsController(),
    );
    Get.lazyPut<PhysicalActivityController>(
      () => PhysicalActivityController(),
    );
    Get.lazyPut<NotesController>(
      () => NotesController(),
    );
    Get.lazyPut<SexActivityController>(
      () => SexActivityController(),
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
