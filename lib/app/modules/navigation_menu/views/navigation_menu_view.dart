import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/navigation_menu_controller.dart';

class NavigationMenuView extends GetView<NavigationMenuController> {
  const NavigationMenuView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80.h,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: "Home",
            ),
            // NavigationDestination(
            //   icon: Icon(Iconsax.calendar_1),
            //   label: "Calender",
            // ),
            NavigationDestination(
              icon: Icon(Iconsax.chart_1),
              label: "Analysis",
            ),
            NavigationDestination(
              icon: Icon(Iconsax.messages),
              label: "Insight",
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
