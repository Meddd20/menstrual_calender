import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';

class LoginController extends GetxController {
  final ApiService apiService = ApiService();
  late final AuthRepository authRepository = AuthRepository(apiService);
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final box = GetStorage();
  late TextEditingController emailC;
  late TextEditingController passwordC;

  var isHidden = true.obs;
  var isAuth = false.obs;

  @override
  void onInit() async {
    super.onInit();
    emailC = TextEditingController();
    passwordC = TextEditingController();
    checkStoredAuth();
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
    try {
      var authCredential =
          await authRepository.login(emailC.text.trim(), passwordC.text.trim());

      storeAuth();
      storeCredentialToken(authCredential["data"]["credential"]["token"]);
      storeAccountId(authCredential["data"]["user"]["id"]);
      Get.offAllNamed(Routes.NAVIGATION_MENU);
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

  void storeCredentialToken(String token) {
    box.write("loginAuth", token);
  }

  void storeAccountId(String id) {
    box.write("loginId", id);
  }

  void storeAuth() {
    box.write("isAuth", true);
  }

  void checkStoredAuth() {
    final storedAuth = box.read("loginAuth");
    if (storedAuth != null) {
      isAuth.value = true;
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
