import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/reset_password_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class CodeVerificationController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  late Map<String, dynamic> verifResponse;
  final pinController = TextEditingController();
  var userEmail = "".obs;
  var verificationCode = "".obs;
  RxInt countdown = 60.obs;
  Timer? timer;

  @override
  void onInit() {
    verifResponse = Get.arguments as Map<String, dynamic>;
    userEmail.value = verifResponse["email"];
    startResendTimer();
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

  Future<void> forgetPassword(context) async {
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.emptyVerificationCode));
    } else {
      Map<String, dynamic> data = await authRepository.validateCodeVerif(
        userEmail.value,
        pinController.text,
        "Lupa Password",
        verifResponse["role"],
      );

      final response = data["data"];
      print(response);
      Get.offAll(() => ResetPasswordView(), arguments: {'email': userEmail.value});
      print({'email': userEmail.value});
    }
  }

  Future<void> resendVerificationCode() async {
    await authRepository.requestVerificationCode(userEmail.value, "Lupa Password");
  }

  void startResendTimer() {
    countdown.value = 60;
    timer?.cancel();

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
}
