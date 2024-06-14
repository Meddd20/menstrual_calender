import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';

import '../controllers/navigation_menu_controller.dart';

class NavigationMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationMenuController>(
      () => NavigationMenuController(),
    );
    Get.lazyPut<HomeMenstruationController>(
      () => HomeMenstruationController(),
    );
  }
}
