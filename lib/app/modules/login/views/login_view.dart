import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_textformfield.dart';
import '../controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/forget_password_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
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
            leading: BackButton(
              color: AppColors.primary,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 35.h),
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
                      SizedBox(height: 50.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          AppLocalizations.of(context)!.loginHeader,
                          style: CustomTextStyle.extraBold(24),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          AppLocalizations.of(context)!.loginDesc,
                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: controller.emailC,
                        labelText: AppLocalizations.of(context)!.email,
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
                          labelText: AppLocalizations.of(context)!.password,
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
                      Container(
                        width: Get.width,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(ForgetPasswordView());
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: CustomTextStyle.semiBold(14, color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ),
                      CustomButton(
                        text: AppLocalizations.of(context)!.login,
                        onPressed: () async {
                          controller.checkLogin();
                        },
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.didntHaveAccount,
                            style: CustomTextStyle.semiBold(15),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => Get.offAllNamed(Routes.ONBOARDING),
                            child: Text(
                              AppLocalizations.of(context)!.registerNow,
                              style: CustomTextStyle.bold(16, color: AppColors.contrast),
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
