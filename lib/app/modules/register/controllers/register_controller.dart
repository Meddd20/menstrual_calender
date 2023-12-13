import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  TextEditingController usernameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController passwordValidateC = TextEditingController();
  var isHidden = true.obs;
  var isHiddenValidate = true.obs;

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

  void checkRegister() {
    final isValid = registerFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registerFormKey.currentState!.save();
    Get.toNamed(Routes.NAVIGATION_MENU);
  }
}
