import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

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
              color: AppColors.primary,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 35.h),
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
                          style: CustomTextStyle.heading2TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Register to back up your data",
                          style: CustomTextStyle.bodyTextStyle(),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: controller.usernameC,
                        labelText: "Username",
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return controller.validateUsername(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        controller: controller.emailC,
                        labelText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return controller.validateEmail(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => CustomTextFormField(
                          controller: controller.passwordC,
                          labelText: "Password",
                          obscureText: controller.isHidden.value,
                          suffixIcon: IconButton(
                            onPressed: () => controller.isHidden.toggle(),
                            icon: controller.isHidden.isTrue
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined),
                          ),
                          validator: (value) {
                            return controller.validatePassword(value!);
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        controller: controller.passwordValidateC,
                        labelText: "Confirm Password",
                        obscureText: true,
                        validator: (value) {
                          return controller
                              .validatePasswordConfirmation(value!);
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomColoredButton(
                        text: "Register",
                        onPressed: () {
                          controller.checkRegister();
                        },
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account?",
                            style: CustomTextStyle.buttonTextStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            child: Text(
                              "Login Now",
                              style: CustomTextStyle.buttonTextStyle(
                                color: AppColors.contrast,
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
