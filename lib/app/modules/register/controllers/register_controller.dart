import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/modules/register/views/register_verification_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class RegisterController extends GetxController {
  late final ProfileService _profileService;
  late final PeriodHistoryService _periodHistoryService;
  late final PregnancyHistoryService _pregnancyHistoryService;
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  late final LocalProfileRepository _localProfileRepository;
  final StorageService storageService = StorageService();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordValidateC = TextEditingController();
  var isHidden = true.obs;
  var isHiddenValidate = true.obs;
  var birthday = "".obs;

  @override
  void onInit() {
    _profileService = ProfileService();
    _localProfileRepository = LocalProfileRepository();
    _periodHistoryService = PeriodHistoryService();
    _pregnancyHistoryService = PregnancyHistoryService();

    var bd = Get.arguments as String? ?? "";
    birthday.value = bd;

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
    OnboardingController onboardingController = Get.find<OnboardingController>();
    DateTime? birthdayValue = onboardingController.birthday.value;
    if (birthdayValue != null || birthday.value != "") {
      await authRepository.register(usernameC.text.trim(), birthdayValue ?? DateTime.parse(birthday.value), emailC.text.trim(), passwordC.text.trim());
      Map<String, dynamic> requestVerificationCode = await authRepository.requestVerificationCode(emailC.text.trim(), "Verifikasi");
      print(requestVerificationCode.toString());

      final requestVerificationCodeResponse = requestVerificationCode["data"];
      print(requestVerificationCodeResponse.toString());
      Get.to(() => RegisterVerificationView(), arguments: requestVerificationCodeResponse);
    }
  }

  void saveDataAsGuest() async {
    OnboardingController onboardingController = Get.find<OnboardingController>();
    DateTime? birthdayValue = onboardingController.birthday.value;
    int purpose = onboardingController.purposes.value;
    List<Map<String, dynamic>> periods = onboardingController.periods;
    await _localProfileRepository.deleteProfile();

    if (birthdayValue != null) {
      await _profileService.createProfile(formatDate(birthdayValue), purpose);
      User? user = await _profileService.getProfile();

      if (user != null && user.id != null) {
        storageService.storeIsPregnant(user.isPregnant!);
        storageService.storeAccountLocalId(user.id!);
        if (purpose == 0) {
          int lamaSiklus = onboardingController.menstruationCycle.value;
          for (int i = 0; i < periods.length; i++) {
            Map<String, dynamic> period = periods[i];
            DateTime haidAwal = DateTime.parse(period['first_period']);
            DateTime haidAkhir = DateTime.parse(period['last_period']);
            await _periodHistoryService.addPeriod(null, haidAwal, haidAkhir, lamaSiklus);
          }
        } else {
          String formattedDate = formatDate(onboardingController.lastPeriodDate.value!);
          await _pregnancyHistoryService.beginPregnancy(DateTime.parse(formattedDate), null);
        }
        storageService.storeIsAuth(true);
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed(Routes.NAVIGATION_MENU);
      }
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
