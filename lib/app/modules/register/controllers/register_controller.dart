import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';
import 'package:periodnpregnancycalender/app/modules/register/views/register_verification_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class RegisterController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordValidateC = TextEditingController();
  var isHidden = true.obs;
  var isHiddenValidate = true.obs;

  String? validateUsername(String username) {
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(username)) {
      return "Username can only contain letters!";
    }
    return null;
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

  String? validatePasswordConfirmation(String passwordConfirmation) {
    if (passwordConfirmation != passwordC.text) {
      return "Password confirmation does not match";
    }
    return null;
  }

  Future<void> register() async {
    try {
      OnboardingController onboardingController = Get.find();
      Map<String, dynamic> data = await authRepository.register(
          usernameC.text.trim(),
          onboardingController.birthday.value,
          emailC.text.trim(),
          passwordC.text.trim());

      Map<String, dynamic> requestVerificationCode = await authRepository
          .requestVerificationCode(emailC.text.trim(), "Verifikasi");

      final requestVerificationCodeResponse = requestVerificationCode["data"];
      Get.to(() => RegisterVerificationView(),
          arguments: requestVerificationCodeResponse);
    } catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text("Error"),
            children: [Text(e.toString())],
          );
        },
      );
    }
  }

  void checkRegister() async {
    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
    await register();
  }
}
