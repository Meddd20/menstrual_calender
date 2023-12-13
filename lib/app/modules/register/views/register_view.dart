import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
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
              key: controller.registerFormKey,
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
                          "Create Account",
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
                      SizedBox(height: 3.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Register to back up your data",
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 1.25,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      TextFormField(
                        controller: controller.usernameC,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return controller.validateUsername(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: controller.emailC,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return controller.validateEmail(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordC,
                          autocorrect: false,
                          obscureText: controller.isHidden.value,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => controller.isHidden.toggle(),
                              icon: controller.isHidden.isTrue
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                            ),
                          ),
                          validator: (value) {
                            return controller.validatePassword(value!);
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: controller.passwordValidateC,
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return controller
                              .validatePasswordConfirmation(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.checkRegister();
                          // controller.registerWithEmail();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFD6666),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(Get.width, 45),
                        ),
                        child: Text(
                          "Register",
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
                            "Have an account?",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.38,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
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
