import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/repositories/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class RegisterVerificationController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late final PregnancyRepository pregnancyRepository =
      PregnancyRepository(apiService);
  late Map<String, dynamic> requestVerificationResponse;
  final pinController = TextEditingController();
  var userEmail = "".obs;
  var verificationCode = "".obs;
  RxInt countdown = 60.obs;
  Timer? timer;
  Map<String, dynamic>? saveMenstruationData = {};

  @override
  void onInit() {
    requestVerificationResponse = Get.arguments as Map<String, dynamic>;
    userEmail.value = requestVerificationResponse["email"];
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

  Future<void> codeVerification() async {
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message:
              "Verification code are empty, please fill the verification code"));
    } else {
      Map<String, dynamic> data = await authRepository.validateCodeVerif(
        userEmail.value,
        pinController.text,
        "Verifikasi",
        requestVerificationResponse["role"],
      );

      if (data["status"] == "success") {
        storePeriodData();
      }
    }
  }

  Future<void> storePeriodData() async {
    OnboardingController onboardingController = Get.find();

    if (onboardingController.purposes == 0) {
      saveMenstruationData = await periodRepository.storePeriod(
        (onboardingController.periods),
        onboardingController.menstruationCycle.value,
        userEmail.value,
      );
    } else {
      saveMenstruationData = await pregnancyRepository.pregnancyBegin(
        onboardingController.lastPeriodDate.toString(),
        userEmail.value,
      );
    }

    if (saveMenstruationData!.isNotEmpty) {
      Get.offNamed(Routes.LOGIN);
    }
  }

  Future<void> resendVerificationCode() async {
    await authRepository.requestVerificationCode(userEmail.value, "Verifikasi");
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
