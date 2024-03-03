import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/home/controllers/daily_log_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/reminder_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReminderController>(
      () => ReminderController(),
    );
    Get.lazyPut<DailyLogController>(
      () => DailyLogController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
