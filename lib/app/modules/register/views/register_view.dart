import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_textformfield.dart';
import '../controllers/register_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class BackupDataView extends GetView<RegisterController> {
  const BackupDataView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: AppColors.white,
          leading: const BackButton(
            color: AppColors.primary,
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 35.h),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    child: Image.asset(
                      'assets/image/backup-illustration.png',
                      width: Get.width,
                      // height: Get.width,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Keep your health data safe",
                    style: CustomTextStyle.heading2TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Create an account to securely back up your health data and access it from any device.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
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
                    text: "I'll Register Later",
                    backgroundColor: Colors.transparent,
                    textColor: Colors.black,
                    onPressed: () {
                      controller.saveDataAsGuest();
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    text: "Register Now",
                    onPressed: () {
                      Get.toNamed(Routes.REGISTER);
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

class RegisterView extends GetView<RegisterController> {
  final bool? isRegisterToExistingData;
  const RegisterView({Key? key, this.isRegisterToExistingData = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
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
            surfaceTintColor: AppColors.white,
            elevation: 0,
            leading: const BackButton(
              color: AppColors.primary,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 35.h),
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
                      SizedBox(height: 50.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Create Account",
                          style: CustomTextStyle.heading1TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Register to securely store your data",
                          style: CustomTextStyle.bodyTextStyle(color: Colors.black.withOpacity(0.8)),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        controller: controller.usernameC,
                        labelText: "Username",
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return controller.validateUsername(value!);
                        },
                        hintText: "Johny the Duck",
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        controller: controller.emailC,
                        labelText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return controller.validateEmail(value!);
                        },
                        hintText: "example@example.com",
                      ),
                      SizedBox(height: 15.h),
                      Obx(
                        () => CustomTextFormField(
                          controller: controller.passwordC,
                          labelText: "Password",
                          obscureText: controller.isHidden.value,
                          suffixIcon: IconButton(
                            onPressed: () => controller.isHidden.toggle(),
                            icon: controller.isHidden.isTrue ? Icon(Icons.remove_red_eye) : Icon(Icons.remove_red_eye_outlined),
                          ),
                          validator: (value) {
                            return controller.validatePassword(value!);
                          },
                          hintText: "•••••••••",
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        controller: controller.passwordValidateC,
                        labelText: "Confirm Password",
                        obscureText: true,
                        validator: (value) {
                          return controller.validatePasswordConfirmation(value!);
                        },
                        hintText: "•••••••••",
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        text: "Register",
                        onPressed: () {
                          controller.checkRegister();
                        },
                      ),
                      if (isRegisterToExistingData == false) ...[
                        SizedBox(height: 15.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "or",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Expanded(
                                child: Divider(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account?",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
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
                      ]
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
