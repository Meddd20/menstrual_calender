import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding3_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding6_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  AppLocalizations.of(context)!.askGoal,
                  style: CustomTextStyle.extraBold(20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  AppLocalizations.of(context)!.askGoalDesc,
                  style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                GestureDetector(
                  onTap: () {
                    controller.purposes.value = 0;
                    Get.to(() => Onboarding3View());
                  },
                  child: Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.trackPeriodGoal,
                                  style: CustomTextStyle.extraBold(20, color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                  "assets/a0ffb3b8a7b12e87a13bac8ea30839d9.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () {
                    controller.purposes.value = 1;
                    Get.to(() => Onboarding6View());
                  },
                  child: Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.pregnancyGoal,
                                  style: CustomTextStyle.extraBold(20, color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                  "assets/582f6eee055d99f5cec860e1df879f99.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
