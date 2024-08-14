import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding1_view.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    width: Get.width,
                    height: 300.h,
                    child: Image.asset('assets/image/bd48b2bc7befdf66265a70239c555886.png'),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Welcome to Our Menstrual and Pregnancy Calendar!",
                    style: CustomTextStyle.bold(22, height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Easily track your menstrual cycle and pregnancy journey. Receive personalized insights and reminders to support your unique experience.",
                    style: CustomTextStyle.medium(14, height: 2.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  CustomButton(
                    text: "I Have an Account",
                    backgroundColor: Colors.transparent,
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    text: "Get Started",
                    onPressed: () {
                      Get.to(() => Onboarding1View());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
