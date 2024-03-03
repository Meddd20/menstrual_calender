import 'package:get/get.dart';

import 'package:periodnpregnancycalender/app/modules/login/controllers/code_verification_controller.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/forget_password_controller.dart';
import 'package:periodnpregnancycalender/app/modules/login/controllers/reset_password_controller.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CodeVerificationController>(
      () => CodeVerificationController(),
    );
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
    Get.put<LoginController>(
      LoginController(),
    );
  }
}
