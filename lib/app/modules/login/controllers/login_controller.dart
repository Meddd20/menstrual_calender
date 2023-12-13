import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/verification_code_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> verifCodeFormKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController forgetEmailC = TextEditingController();
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController newPasswordConfirmationC = TextEditingController();

  var isHidden = true.obs;
  var isHiddenReset = true.obs;
  RxInt countdown = 60.obs;
  Timer? timer;
  var verificationCode = "".obs;

  void onVerificationCodeCompleted(String pin) {
    if (verificationCode.value.isEmpty || verificationCode.value.length < 6) {
      Get.snackbar("Error", "Verification code is null");
    } else {
      print("Verification code: $pin");
    }
  }

  String? validateEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email!";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    Get.offAllNamed(Routes.NAVIGATION_MENU);
  }

  String? validateForgetEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email!";
    }
    return null;
  }

  void checkEmailForgetPassword() {
    final isValid = forgetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    forgetPasswordFormKey.currentState!.save();
    Get.offAll(() => VerificationCodeView());
  }

  void startResendTimer() {
    countdown.value = 60;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer t) {
        if (countdown.value == 0) {
          timer?.cancel();
        } else {
          countdown.value--;
        }
      },
    );
  }

  String? validateNewPassword(String password) {
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  String? NewPasswordValidation(String passwordConfirmation) {
    if (passwordConfirmation != newPasswordC.text) {
      return "New password confirmation does not match";
    }
    return null;
  }

  void checkNewPassword() {
    final isValid = verifCodeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    verifCodeFormKey.currentState!.save();
    Get.offAll(Routes.NAVIGATION_MENU);
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
