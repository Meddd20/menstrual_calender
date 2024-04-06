import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
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
                    "How long does your period usually last?",
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
                  scrollController: FixedExtentScrollController(initialItem: 6),
                  children: List.generate(
                    10,
                    (index) {
                      final day = index + 1;
                      return Center(
                        child: Text(
                          "$day days",
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
                    controller.periodLast.value = index + 1;
                    print(controller.periodLast.value);
                  },
                ),
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
                    Get.to(() => Onboarding5View());
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
