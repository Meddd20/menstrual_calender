import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/insight/controllers/insight_detail_controller.dart';

import '../controllers/insight_controller.dart';

class InsightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightDetailController>(
      () => InsightDetailController(),
    );
    Get.lazyPut<InsightController>(() {
      print('InsightBinding applied');
      return InsightController();
    });
  }
}
