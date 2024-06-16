import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/login_view.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/views/weight_gain_tracker_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/profile_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding1_view.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xFFf9f8fb),
          surfaceTintColor: Color(0xFFf9f8fb),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 85.h),
                Container(
                  width: 320.w,
                  height: 309.h,
                  child: Image.asset(
                      'assets/image/bd48b2bc7befdf66265a70239c555886.png'),
                ),
                SizedBox(height: 30.h),
                Text(
                  "Lorem ipsum dolor sit amet dot dot dot",
                  style: CustomTextStyle.heading3TextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15.h),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                  style: CustomTextStyle.bodyTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20.h),
                CustomTransparentButton(
                  text: "I Have an Account",
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.toNamed(Routes.LOGIN);
                    });
                  },
                ),
                SizedBox(height: 5.h),
                CustomColoredButton(
                  text: "Get Started",
                  onPressed: () {
                    Get.to(() => Onboarding1View());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
