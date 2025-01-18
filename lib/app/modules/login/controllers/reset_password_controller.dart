import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';

class ResetPasswordController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> verifCodeFormKey = GlobalKey<FormState>();
  late Map<String, dynamic> emailResetPassword;
  TextEditingController newPasswordC = TextEditingController();
  TextEditingController newPasswordConfirmationC = TextEditingController();

  var userEmail = "".obs;
  var isHidden = true.obs;

  @override
  void onInit() {
    emailResetPassword = Get.arguments as Map<String, dynamic>;
    userEmail.value = emailResetPassword['email'] ?? '';
    print(userEmail.value);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> resetPassword() async {
    Map<String, dynamic> data = await authRepository.resetPassword(userEmail.value, newPasswordC.text.trim(), newPasswordConfirmationC.text.trim());

    final verifResponse = data["message"];
    print(verifResponse);
    Get.offAllNamed(Routes.LOGIN);
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
    resetPassword();
  }
}
