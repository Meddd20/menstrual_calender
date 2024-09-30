import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_menstruation_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_pregnancy_view.dart';
import 'package:periodnpregnancycalender/app/modules/navigation_menu/controllers/navigation_menu_controller.dart';

class HomeView extends GetView<NavigationMenuController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(NavigationMenuController());
    return Obx(() {
      return controller.isPregnant.value == "0" ? HomeMenstruationView() : HomePregnancyView();
    });
  }
}
