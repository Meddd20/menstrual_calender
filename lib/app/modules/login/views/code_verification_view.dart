import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_pinput.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/code_verification_controller.dart';

class CodeVerificationView extends GetView<CodeVerificationController> {
  const CodeVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.fromLTRB(15.w, 40.h, 15.w, 35.h),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 90.h),
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
                        child: Text.rich(
                          TextSpan(
                            text: "Please enter the verification code sent to ",
                            style: CustomTextStyle.captionTextStyle(),
                            children: [
                              TextSpan(
                                text: "${controller.userEmail}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: CustomTextStyle.captionTextStyle().color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    CustomPinInput(
                      controller: controller.pinController,
                      length: 6,
                      showCursor: true,
                    ),
                    SizedBox(height: 25.h),
                    CustomButton(
                      text: "Send Code",
                      onPressed: () {
                        controller.forgetPassword();
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive any code?  ",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
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
