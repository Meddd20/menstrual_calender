import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';
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
    try {
      Map<String, dynamic> data = await authRepository.requestVerificationCode(
          forgetEmailC.text.trim(), "Lupa Password");

      final verifResponse = data["data"];
      print(verifResponse);
      Get.offAll(() => CodeVerificationView(), arguments: verifResponse);
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
