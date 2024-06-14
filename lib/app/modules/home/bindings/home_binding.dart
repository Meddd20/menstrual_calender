import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/daily_log_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_pregnancy_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/reminder_controller.dart';

import '../controllers/home_menstruation_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePregnancyController>(
      () => HomePregnancyController(),
    );
    Get.lazyPut<ReminderController>(
      () => ReminderController(),
    );
    Get.lazyPut<DailyLogController>(
      () => DailyLogController(),
    );
    Get.lazyPut<HomeMenstruationController>(
      () => HomeMenstruationController(),
    );
    Get.lazyPut<PeriodCycleController>(
      () => PeriodCycleController(),
    );
  }
}
