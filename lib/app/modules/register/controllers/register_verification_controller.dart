import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';

class RegisterVerificationController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late Map<String, dynamic> requestVerificationResponse;
  final pinController = TextEditingController();
  var userEmail = "".obs;
  var verificationCode = "".obs;
  RxInt countdown = 60.obs;
  Timer? timer;

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
    print(pinController.value);
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: Text("Error"),
            children: [Text("Fill the verification code")],
          );
        },
      );
    }

    try {
      Map<String, dynamic> data = await authRepository.validateCodeVerif(
        userEmail.value,
        pinController.text,
        "Verifikasi",
        requestVerificationResponse["role"],
      );

      final response = data["status"];
      print(response);
      if (response == "success") {
        storePeriodData();
      } else {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Error"),
              children: [Text("Verification failed: $response")],
            );
          },
        );
      }
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

  Future<void> storePeriodData() async {
    try {
      OnboardingController onboardingController = Get.find();
      print(onboardingController.periods);
      Map<String, dynamic> saveMenstruationData =
          await periodRepository.storePeriod(
        (onboardingController.periods),
        onboardingController.menstruationCycle.value,
        userEmail.value,
      );

      final status = saveMenstruationData["status"];
      final message = saveMenstruationData["message"];

      if (status == "success") {
        Get.offNamed(Routes.LOGIN);
      } else {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text("Error"),
              children: [Text(message ?? "Unknown error occurred")],
            );
          },
        );
      }
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

  Future<void> resendVerificationCode() async {
    try {
      Map<String, dynamic> requestVerificationCode = await authRepository
          .requestVerificationCode(userEmail.value, "Verifikasi");
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
