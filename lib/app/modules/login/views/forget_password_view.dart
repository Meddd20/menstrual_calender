import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/login_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class ForgetPasswordView extends GetView<LoginController> {
  const ForgetPasswordView({Key? key}) : super(key: key);
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(
              color: Color(0xFFFD6666),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(35),
            ),
            child: Form(
              key: controller.forgetPasswordFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 130.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Forgot your password?",
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
                          "Don’t worry! It happens. Please enter the email associated with your account.",
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 1.5,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            letterSpacing: 0.45,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        controller: controller.forgetEmailC,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return controller.validateForgetEmail(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.checkEmailForgetPassword();
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
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember your password?",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.38,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.until((route) =>
                                  route.settings.name == Routes.ONBOARDING);
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: Text(
                              "Login Now",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.38,
                                color: Color(0xFF35C2C1),
                              ),
                            ),
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
      ),
    );
  }
}
