import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/login_controller.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/reset_password_view.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeView extends GetView<LoginController> {
  const VerificationCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
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
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(35),
            ),
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
                        style: TextStyle(
                          fontSize: 24.sp,
                          height: 1.25,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: Get.width,
                      child: Text(
                        "Please type verification code send to helloworld@gmail.com",
                        style: TextStyle(
                          fontSize: 16.sp,
                          height: 1.5,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    Pinput(
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(30, 60, 87, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(234, 239, 243, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      length: 6,
                      showCursor: true,
                      onCompleted: controller.onVerificationCodeCompleted,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      focusedPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(30, 60, 87, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(114, 178, 238, 1)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(30, 60, 87, 1),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(234, 239, 243, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    ElevatedButton(
                      onPressed: () {
                        Get.off(() => ResetPasswordView());
                        // controller.checkEmailForgetPassword();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFD6666),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(Get.width, 45),
                      ),
                      child: Text(
                        "Send Code",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive any code?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.38,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Start the countdown timer and show the countdown text
                            controller.startResendTimer();
                          },
                          child: Text(
                            "Resend OTP",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.38,
                              color: Color(0xFF35C2C1),
                            ),
                          ),
                        ),
                        Obx(
                          () {
                            return Text(
                              controller.countdown.value > 0
                                  ? "(${controller.countdown})"
                                  : "",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.38,
                              ),
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
