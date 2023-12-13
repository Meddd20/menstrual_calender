import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/login_controller.dart';

class ResetPasswordView extends GetView<LoginController> {
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
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(0),
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(35),
            ),
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
                          "Your new password should be different from passwords previously used",
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
                      Obx(
                        () => TextFormField(
                          controller: controller.newPasswordC,
                          autocorrect: false,
                          obscureText: controller.isHidden.value,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => controller.isHidden.toggle(),
                              icon: controller.isHiddenReset.isTrue
                                  ? Icon(Icons.remove_red_eye)
                                  : Icon(Icons.remove_red_eye_outlined),
                            ),
                          ),
                          validator: (value) {
                            return controller.validateNewPassword(value!);
                          },
                        ),
                      ),
                      SizedBox(height: 25.h),
                      TextFormField(
                        controller: controller.newPasswordConfirmationC,
                        autocorrect: false,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirmation New Password",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          return controller.NewPasswordValidation(value!);
                        },
                      ),
                      SizedBox(height: 25.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.checkNewPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFD6666),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: Size(Get.width, 45),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.38,
                            color: Colors.white,
                          ),
                        ),
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
