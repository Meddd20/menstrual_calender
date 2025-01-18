import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/register/controllers/register_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

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

  Future<void> codeVerification(context) async {
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.emptyVerificationCode));
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
            storageService.storeIsBackup(false);
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
