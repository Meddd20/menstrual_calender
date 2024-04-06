import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/forget_password_view.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
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
              key: controller.loginFormKey,
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
                          "Welcome Back..",
                          style: CustomTextStyle.heading1TextStyle(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          "Glad to see you again!",
                          style: CustomTextStyle.captionTextStyle(),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: controller.emailC,
                        labelText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return controller.validateEmail(value!);
                        },
                        hintText: "example@example.com",
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
                          hintText: "•••••••••",
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(ForgetPasswordView());
                            },
                            child: Text(
                              "Forgot Password?",
                              style: CustomTextStyle.bodyTextStyle(),
                            ),
                          ),
                        ),
                      ),
                      CustomColoredButton(
                        text: "Login",
                        onPressed: () async {
                          controller.checkLogin();
                        },
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account?",
                            style: CustomTextStyle.captionTextStyle(),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.until((route) =>
                                  route.settings.name == Routes.ONBOARDING);
                              Get.toNamed(Routes.REGISTER);
                            },
                            child: Text(
                              "Register Now",
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
