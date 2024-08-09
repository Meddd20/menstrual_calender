import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_pinput.dart';
import 'package:periodnpregnancycalender/app/modules/register/controllers/register_verification_controller.dart';

class RegisterVerificationView extends GetView<RegisterVerificationController> {
  const RegisterVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterVerificationController());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Padding(
            padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 35.h),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 130.h),
                    Container(
                      width: Get.width,
                      child: Text(
                        "Verification Code",
                        style: CustomTextStyle.heading1TextStyle(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Container(
                        width: Get.width,
                        child: Text(
                          "Please enter verification code send to ${controller.userEmail}",
                          style: CustomTextStyle.captionTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    CustomPinInput(
                      controller: controller.pinController,
                      length: 6,
                      showCursor: true,
                    ),
                    SizedBox(height: 25.h),
                    CustomButton(
                      text: "Send Code",
                      onPressed: () {
                        controller.codeVerification();
                      },
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive any code?  ",
                          style: CustomTextStyle.captionTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (controller.countdown.value == 0) {
                              await controller.resendVerificationCode();
                              controller.startResendTimer();
                            }
                          },
                          child: Text(
                            "Resend OTP  ",
                            style: CustomTextStyle.buttonTextStyle(
                              color: AppColors.contrast,
                            ),
                          ),
                        ),
                        Obx(
                          () {
                            return Text(
                              controller.countdown.value > 0 ? "(${controller.countdown})" : "",
                              style: CustomTextStyle.buttonTextStyle(),
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
