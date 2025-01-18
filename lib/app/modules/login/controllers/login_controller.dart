import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

class LoginController extends GetxController {
  late final ProfileService _profileService;
  late final LocalProfileRepository _localProfileRepository;
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  late final ProfileRepository profileRepository = ProfileRepository(apiService);
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final box = GetStorage();
  final StorageService storageService = StorageService();
  late TextEditingController emailC;
  late TextEditingController passwordC;
  Rx<bool?> overrideExistingData = Rx<bool?>(false);
  var isHidden = true.obs;

  @override
  void onInit() async {
    _localProfileRepository = LocalProfileRepository();
    _profileService = ProfileService();

    emailC = TextEditingController();
    passwordC = TextEditingController();
    final arguments = Get.arguments;
    if (arguments != null && arguments is bool) {
      overrideExistingData.value = arguments;
    }
    super.onInit();
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  Future<void> login(context) async {
    try {
      User? user = await authRepository.login(emailC.text.trim(), passwordC.text.trim());
      User? localProfile = await _profileService.getProfile();

      if (user == null || user.token == null) {
        return;
      }

      if (localProfile == null) {
        await _profileService.createLoginProfile(
          user.nama!,
          user.tanggalLahir!,
          int.parse(user.isPregnant!),
          user.email!,
        );
        localProfile = await _profileService.getProfile();
      } else {
        User updatedProfile = localProfile.copyWith(
          nama: user.nama,
          tanggalLahir: user.tanggalLahir,
          isPregnant: user.isPregnant,
          email: user.email,
        );
        await _localProfileRepository.updateProfile(updatedProfile);
        localProfile = updatedProfile;
      }

      if (localProfile != null) {
        storageService.storeCredentialToken(user.token!);

        // if (storageService.getAccountLocalId() != 0) {
        if (overrideExistingData.value == true) {
          storageService.storeIsAccountCreatedUnverified(true);
        }
        // } else {
        //   storageService.storeAccountLocalId(localProfile.id ?? 0);
        // }

        Get.offAllNamed(Routes.NAVIGATION_MENU, arguments: overrideExistingData.value);
        FirebaseNotificationService().storeFcmToken(user.id!);
        storageService.storeIsAuth(true);
        storageService.storeAccountId(user.id!);
        overrideExistingData.value == false ? storageService.storeIsPregnant(user.isPregnant!) : null;
        storageService.storeIsBackup(true);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.loginFailed));
    }
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

  void checkLogin(context) async {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    await login(context);
  }
}
