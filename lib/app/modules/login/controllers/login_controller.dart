import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class LoginController extends GetxController {
  late final ProfileService _profileService;
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final box = GetStorage();
  final storageService = StorageService();
  late TextEditingController emailC;
  late TextEditingController passwordC;

  var isHidden = true.obs;

  @override
  void onInit() async {
    final databaseHelper = DatabaseHelper.instance;
    final localProfileRepository = LocalProfileRepository(databaseHelper);
    _profileService = ProfileService(localProfileRepository);
    emailC = TextEditingController();
    passwordC = TextEditingController();
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

  Future<void> login() async {
    UserData? userData = await authRepository.login(emailC.text.trim(), passwordC.text.trim());

    if (userData != null) {
      Credential? userCredential = userData.credential;
      User? user = userData.user;

      if (user != null && userCredential != null) {
        _profileService.createLoginProfile(user.nama ?? "", user.tanggalLahir ?? "${DateTime.now()}", int.parse(user.isPregnant ?? "0"));
        User? userProfileLocal = await _profileService.getProfile();

        if (userProfileLocal != null) {
          storageService.storeIsAuth(true);
          storageService.storeCredentialToken(userCredential.token!);
          storageService.storeAccountId(userCredential.userId!);
          storageService.storeIsPregnant(user.isPregnant!);
          storageService.storeAccountLocalId(userProfileLocal.id!);
          storageService.storePrimaryDataMechanism();
          Get.offAllNamed(Routes.NAVIGATION_MENU);
        }
      }
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

  void checkLogin() async {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    await login();
  }
}
