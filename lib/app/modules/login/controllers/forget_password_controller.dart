import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/code_verification_view.dart';

class ForgetPasswordController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController forgetEmailC = TextEditingController();

  @override
  void onInit() {
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

  Future<void> forgetPassword() async {
    Map<String, dynamic> data = await authRepository.requestVerificationCode(forgetEmailC.text.trim(), "Lupa Password");

    final verifResponse = data["data"];
    Get.to(() => CodeVerificationView(), arguments: verifResponse);
  }

  String? validateForgetEmail(String email) {
    if (!GetUtils.isEmail(email)) {
      return "Please enter a valid email!";
    }
    return null;
  }

  void checkEmailForgetPassword() async {
    final isValid = forgetPasswordFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    forgetPasswordFormKey.currentState!.save();
    await forgetPassword();
  }
}
