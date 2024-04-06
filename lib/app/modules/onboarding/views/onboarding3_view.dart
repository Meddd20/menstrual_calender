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
          backgroundColor: Color(0xFFf9f8fb),
          surfaceTintColor: Color(0xFFf9f8fb),
          leading: BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 70.h),
                CustomCircularIconContainer(
                  iconData: Icons.crisis_alert,
                  iconSize: 35,
                  iconColor: AppColors.primary,
                  containerColor: AppColors.highlight,
                  containerSize: 30.dg,
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "How many days does your cycle last on average?",
                    style: CustomTextStyle.heading3TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 7.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Predict your next period from your last period",
                    style: CustomTextStyle.bodyTextStyle(),
                    textAlign: TextAlign.left,
                  ),
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
                          "$day Days",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
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
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 35),
                child: CustomColoredButton(
                  text: "Next",
                  onPressed: () {
                    Get.to(() => Onboarding4View());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
