import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/baby_weight_heigth_tracker_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/food_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/vaccine_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/vitamin_list_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/weight_tracker_view.dart';

import '../controllers/pregnancy_tools_controller.dart';

class PregnancyToolsView extends GetView<PregnancyToolsController> {
  const PregnancyToolsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> tools = [
      {'name': 'Fetal Development', 'icon': 'assets/icon/fetal.png'},
      {'name': 'Weight Gain Tracker', 'icon': 'assets/icon/weight-tracker.png'},
      {'name': 'Reminder', 'icon': 'assets/icon/alarm.png'},
      {'name': 'Vaccine', 'icon': 'assets/icon/vaccine.png'},
      {'name': 'Vitamins', 'icon': 'assets/icon/vitamin.png'},
      {'name': 'Food', 'icon': 'assets/icon/nutrition.png'},
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Pregnancy Tools',
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      Get.to(() => BabyWeightHeigthTrackerView());
                      break;
                    case 1:
                      Get.to(() => WeightTrackerView());
                      break;
                    case 2:
                      Get.to(() => ReminderView());
                      break;
                    case 3:
                      Get.to(() => VaccineListView());
                      break;
                    case 4:
                      Get.to(() => VitaminListView());
                      break;
                    case 5:
                      Get.to(() => FoodListView());
                      break;
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(tool['icon'] ?? "", height: 80, width: 80),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tool['name'] ?? "",
                          style: CustomTextStyle.semiBold(15, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
