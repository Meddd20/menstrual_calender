import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding3_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding6_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class Onboarding2View extends GetView<OnboardingController> {
  const Onboarding2View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: AppColors.white,
          leading: const BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 15.h),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CustomCircularIcon(
                  iconData: Icons.crisis_alert,
                  iconSize: 35,
                  iconColor: AppColors.primary,
                  containerColor: AppColors.highlight,
                  containerSize: 30.dg,
                ),
                SizedBox(height: 25.h),
                Text(
                  "What’s your current goal?",
                  style: CustomTextStyle.heading3TextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Pick the goal that best fits you. All features are available for you to explore!",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                ElevatedButton(
                  onPressed: () {
                    controller.purposes.value = 0;
                    Get.to(() => Onboarding3View());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: Get.width,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50.h,
                          width: 128.w,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22),
                            child: Text(
                              "Tracking my period",
                              style: CustomTextStyle.heading3TextStyle(color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: 178.w,
                          height: 119.h,
                          child: Image.asset(
                            "assets/a0ffb3b8a7b12e87a13bac8ea30839d9.png",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                ElevatedButton(
                  onPressed: () {
                    controller.purposes.value = 1;
                    Get.to(() => Onboarding6View());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: Get.width,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50.h,
                          width: 128.w,
                          child: Padding(
                            padding: EdgeInsets.only(left: 22),
                            child: Text(
                              "Follow my pregnancy",
                              style: CustomTextStyle.heading3TextStyle(color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          width: 178.w,
                          height: 119.h,
                          child: Image.asset(
                            "assets/582f6eee055d99f5cec860e1df879f99.png",
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
