import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_pinput.dart';
import 'package:periodnpregnancycalender/app/modules/register/controllers/register_verification_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterVerificationView extends GetView<RegisterVerificationController> {
  const RegisterVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterVerificationController());
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
                        AppLocalizations.of(context)!.verificationHeader,
                        style: CustomTextStyle.extraBold(24),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Obx(
                      () => Container(
                        width: Get.width,
                        child: Text.rich(
                          TextSpan(
                            text: AppLocalizations.of(context)!.verificationDesc,
                            style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                            children: [
                              TextSpan(
                                text: "${controller.userEmail}",
                                style: CustomTextStyle.extraBold(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    CustomPinInput(
                      controller: controller.pinController,
                      length: 6,
                      showCursor: true,
                    ),
                    SizedBox(height: 25.h),
                    CustomButton(
                      text: AppLocalizations.of(context)!.sendCode,
                      onPressed: () {
                        controller.codeVerification(context);
                      },
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.codeNotReceived,
                          style: CustomTextStyle.medium(16, height: 1.5),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (controller.countdown.value == 0) {
                              await controller.resendVerificationCode();
                              controller.startResendTimer();
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.resendOTP,
                            style: CustomTextStyle.bold(16, color: AppColors.contrast),
                          ),
                        ),
                        Obx(
                          () {
                            return Text(
                              controller.countdown.value > 0 ? "(${controller.countdown})" : "",
                              style: CustomTextStyle.bold(16),
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
