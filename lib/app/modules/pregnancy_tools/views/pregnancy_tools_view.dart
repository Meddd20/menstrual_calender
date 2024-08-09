import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/baby_weight_heigth_tracker_view.dart';
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
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PregnancyToolsView'),
          centerTitle: true,
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
                      Text(tool['name'] ?? "", style: TextStyle(fontSize: 16)),
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
