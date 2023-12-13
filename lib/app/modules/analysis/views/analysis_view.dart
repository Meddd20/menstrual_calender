import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:periodnpregnancycalender/app/widgets/custom_icon_card.dart';

import '../controllers/analysis_controller.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analysis'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Align(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Cycles',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(Iconsax.arrow_right_34)
                              ],
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.74),
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.38,
                                ),
                                children: [
                                  TextSpan(text: '1'),
                                  TextSpan(text: ' cycle history logged'),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 100,
                                  width: Get.width / 2 - 50,
                                  decoration: BoxDecoration(
                                    color: Color(0x4CFF6868),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 3,
                                      color: Color(0xFFF4F4F4),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Average Period',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "7 Days",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Iconsax.activity,
                                            size: 15,
                                            color: Color(0xFFFF6868),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Container(
                                  height: 100,
                                  width: Get.width / 2 - 50,
                                  decoration: BoxDecoration(
                                    color: Color(0x6625BF91),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 3, color: Color(0xFFF4F4F4)),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Average Cycle',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              "28 Days",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Iconsax.activity,
                                            size: 15,
                                            color: Color(0xFF44C89F),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        height: 515,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(width: 0.5, color: Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: GridView(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 6,
                            ),
                            children: [
                              CustomIconCard(
                                  icon: Icons.crisis_alert,
                                  text: "Pregnancy Signs"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert,
                                  text: "Sex Activity"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Symptoms"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert,
                                  text: "Vaginal Discharge"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Moods"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Others"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert,
                                  text: "Temperature"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Weight"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Reminder"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert, text: "Notes"),
                              CustomIconCard(
                                  icon: Icons.crisis_alert,
                                  text: "Period & Cycle"),
                              CustomIconCard(
                                icon: Icons.crisis_alert,
                                text: "Period & Cycle",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
