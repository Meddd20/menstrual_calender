import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_cupertino_picker.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
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
          surfaceTintColor: AppColors.white,
          leading: BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0.w, 40.h, 0.w, 35.h),
              child: Column(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "How Long is Your Average Menstrual Cycle?",
                      style: CustomTextStyle.heading3TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "We'll use this to help predict your next period based on your last one.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
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
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: CustomButton(
                text: "Next",
                onPressed: () {
                  Get.to(() => Onboarding4View());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
