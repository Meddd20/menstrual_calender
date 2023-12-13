import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding5_view.dart';

class Onboarding4View extends GetView<OnboardingController> {
  const Onboarding4View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Color(0xFFFD6666),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
              children: [
                SizedBox(height: 70.h),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFC7C7),
                  ),
                  child: Icon(
                    Icons.crisis_alert, // Replace with your desired icon
                    size: 35,
                    color: Color(0xFFFF6868), // Customize the icon color here
                  ),
                ),
                SizedBox(height: 25.h),
                Text(
                  "How long does your period usually last?",
                  style: TextStyle(
                    fontSize: 18.sp,
                    height: 1.25,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7.h),
                Text(
                  "Predict your next period from your last period",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 2.0,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                Container(
                  height: 250.h,
                  child: CupertinoPicker(
                    itemExtent: 45,
                    magnification: 1.22,
                    looping: true,
                    useMagnifier: true,
                    scrollController:
                        FixedExtentScrollController(initialItem: 6),
                    children: List.generate(
                      10,
                      (index) {
                        final day = index + 1;
                        return Center(
                          child: Text(
                            "$day days",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      },
                    ),
                    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                      background: Color(0xFFFFE6E6).withOpacity(0.3),
                    ),
                    onSelectedItemChanged: (index) {
                      controller.periodLast.value = index + 1;
                      print(controller.periodLast.value);
                    },
                  ),
                ),
                SizedBox(height: 150.h),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => Onboarding5View());
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFD6666),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: Size(Get.width, 45.h)),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.38,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
