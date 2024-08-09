import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_loading_indicator.dart';
import '../controllers/navigation_menu_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationMenuView extends GetView<NavigationMenuController> {
  NavigationMenuView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(NavigationMenuController());
    return FutureBuilder<void>(
      future: controller.initializeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: CustomLoadingIndicator(),
          );
        } else {
          return Obx(
            () => Scaffold(
              bottomNavigationBar: NavigationBar(
                height: 80.h,
                indicatorColor: AppColors.highlight,
                elevation: 0,
                selectedIndex: controller.selectedIndex.value,
                onDestinationSelected: (index) => controller.selectedIndex.value = index,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Iconsax.home),
                    label: "Home",
                  ),
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
              body: controller.screens[controller.selectedIndex.value],
            ),
          );
        }
      },
    );
  }
}
