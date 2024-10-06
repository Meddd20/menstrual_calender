import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnauthorizedErrorView extends GetView<ProfileController> {
  const UnauthorizedErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/icon/not-found.png',
                  width: Get.width / 1.5,
                ),
              ),
              SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.accountActivityDetected,
                style: CustomTextStyle.extraBold(24, height: 1.75),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                child: Text(
                  AppLocalizations.of(context)!.accountActivityDetectedDesc,
                  style: CustomTextStyle.medium(16, height: 1.75, color: Colors.black.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => controller.performLogout(),
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
                  AppLocalizations.of(context)!.logout,
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
