import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding4_view.dart';

class Onboarding3View extends GetView<OnboardingController> {
  const Onboarding3View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
          child: Align(
            child: Column(
              children: [
                SizedBox(height: 70.h),
                CustomCircularIconContainer(
                  iconData: Icons.crisis_alert,
                  iconSize: 35,
                  iconColor: AppColors.primary,
                  containerColor: AppColors.highlight,
                ),
                SizedBox(height: 25.h),
                Text(
                  "How many days does your cycle last on average?",
                  style: CustomTextStyle.heading3TextStyle(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7.h),
                Text(
                  "Predict your next period from your last period",
                  style: CustomTextStyle.bodyTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                CustomCupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: 8),
                  children: List.generate(
                    21,
                    (index) {
                      final day = index + 20;
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
                  onSelectedItemChanged: (index) {
                    controller.menstruationCycle.value = index + 20;
                    print(controller.menstruationCycle.value);
                  },
                ),
                SizedBox(height: 150.h),
                CustomColoredButton(
                  text: "Next",
                  onPressed: () {
                    Get.to(() => Onboarding4View());
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
