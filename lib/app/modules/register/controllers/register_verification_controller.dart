import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/modules/register/controllers/register_controller.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/period_repository.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class RegisterVerificationController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late Map<String, dynamic> requestVerificationResponse;
  final StorageService storageService = StorageService();
  final pinController = TextEditingController();
  final RegisterController registerController = Get.find<RegisterController>();
  late final ProfileService _profileService;
  late final LocalProfileRepository _localProfileRepository;
  var userEmail = "".obs;
  var verificationCode = "".obs;
  RxInt countdown = 60.obs;
  Timer? timer;
  Map<String, dynamic>? saveMenstruationData = {};

  @override
  void onInit() {
    _localProfileRepository = LocalProfileRepository();
    _profileService = ProfileService();
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
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Verification code are empty, please fill the verification code"));
    } else {
      Map<String, dynamic> data = await authRepository.validateCodeVerif(
        userEmail.value,
        pinController.text,
        "Verifikasi",
        requestVerificationResponse["role"],
      );

      if (data["status"] == "success") {
        if (storageService.getAccountLocalId() != 0 && storageService.getCredentialToken() == null) {
          storePeriodData();
          Get.offNamed(Routes.LOGIN, arguments: true);
        } else {
          User? user = await authRepository.login(registerController.emailC.text.trim(), registerController.passwordC.text.trim());
          if (user != null && user.token != null) {
            User? localProfile = await _profileService.getProfile();
            if (localProfile != null) {
              User updatedProfile = localProfile.copyWith(
                nama: user.nama,
                tanggalLahir: user.tanggalLahir,
                isPregnant: user.isPregnant,
                email: user.email,
              );
              await _localProfileRepository.updateProfile(updatedProfile);
              localProfile = updatedProfile;
            }
            storageService.storeCredentialToken(user.token!);
            storageService.storeIsAuth(true);
            storageService.storeAccountId(user.id!);
            storageService.storeIsBackup(true);
            Get.offAllNamed(Routes.NAVIGATION_MENU);
          }
        }
      }
    }
  }

  Future<void> storePeriodData() async {
    OnboardingController onboardingController = Get.find();

    if (onboardingController.purposes == 0) {
      await periodRepository.storePeriod(
        (onboardingController.periods),
        onboardingController.menstruationCycle.value,
        userEmail.value,
      );
    } else {
      await pregnancyRepository.pregnancyBegin(
        onboardingController.lastPeriodDate.toString(),
        userEmail.value,
      );
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
