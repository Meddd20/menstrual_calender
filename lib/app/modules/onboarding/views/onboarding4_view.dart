import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_cupertino_picker.dart';
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "How Long Does Your Period Usually Last?",
                      style: CustomTextStyle.heading3TextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Knowing this helps us predict your next period more accurately.",
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
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: CustomButton(
                text: "Next",
                onPressed: () {
                  Get.to(() => Onboarding5View());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
