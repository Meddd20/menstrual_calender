import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_textformfield.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/forget_password_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ForgetPasswordController());
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
            padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 35.h),
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
                      SizedBox(height: 50.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          AppLocalizations.of(context)!.forgetPasswordHeader,
                          style: CustomTextStyle.extraBold(24),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          AppLocalizations.of(context)!.forgetPasswordDesc,
                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      CustomTextFormField(
                        controller: controller.forgetEmailC,
                        labelText: AppLocalizations.of(context)!.email,
                        validator: (value) {
                          return controller.validateForgetEmail(value!);
                        },
                        hintText: "example@example.com",
                      ),
                      SizedBox(height: 25.h),
                      CustomButton(
                        text: AppLocalizations.of(context)!.sendCode,
                        onPressed: () {
                          controller.checkEmailForgetPassword();
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
