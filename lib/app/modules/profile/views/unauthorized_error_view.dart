import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/profile_controller.dart';

class UnauthorizedErrorView extends GetView<ProfileController> {
  const UnauthorizedErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/image/alert.png',
                  width: Get.width,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Account Activity Detected",
                style: CustomTextStyle.extraBold(24, height: 1.75),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                child: Text(
                  "We detected a login on another device. Please sign in again to secure your account.",
                  style: CustomTextStyle.medium(16, height: 1.75, color: Colors.black.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  controller.performLogout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: AppColors.primary,
                  minimumSize: Size(Get.width / 2, 50.h),
                ),
                child: Text(
                  "Logout",
                  style: CustomTextStyle.bold(16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
