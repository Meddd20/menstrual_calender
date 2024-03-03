import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class Onboarding7View extends GetView<OnboardingController> {
  const Onboarding7View({Key? key}) : super(key: key);
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
                  "How long does your period usually last?",
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
                  scrollController: FixedExtentScrollController(initialItem: 9),
                  children: List.generate(
                    40,
                    (index) {
                      final day = index + 1;
                      return Center(
                        child: Text(
                          "$day weeks",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    },
                  ),
                  onSelectedItemChanged: (index) {
                    controller.pregnantWeek.value = index + 1;
                    print(controller.pregnantWeek.value);
                  },
                ),
                SizedBox(height: 150.h),
                CustomColoredButton(
                  text: "Calculate",
                  onPressed: () {
                    Get.offNamed(Routes.REGISTER);
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
