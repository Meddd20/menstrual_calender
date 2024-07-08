import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_textformfield.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
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
            padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 35.h),
            child: Form(
              key: controller.verifCodeFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          "Enter Your New Password",
                          style: CustomTextStyle.heading1TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Please enter your new password. Make it secure and easy to remember.",
                          style: CustomTextStyle.captionTextStyle(),
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Obx(
                        () => CustomTextFormField(
                          controller: controller.newPasswordC,
                          labelText: "New Password",
                          obscureText: controller.isHidden.value,
                          suffixIcon: IconButton(
                            onPressed: () => controller.isHidden.toggle(),
                            icon: controller.isHidden.isTrue ? Icon(Icons.remove_red_eye) : Icon(Icons.remove_red_eye_outlined),
                          ),
                          validator: (value) {
                            return controller.validateNewPassword(value!);
                          },
                        ),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextFormField(
                        controller: controller.newPasswordConfirmationC,
                        labelText: "Confirmation New Password",
                        obscureText: true,
                        validator: (value) {
                          return controller.NewPasswordValidation(value!);
                        },
                      ),
                      SizedBox(height: 25.h),
                      CustomButton(
                        text: "Confirm your new password",
                        onPressed: () {
                          controller.checkNewPassword();
                        },
                      ),
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
