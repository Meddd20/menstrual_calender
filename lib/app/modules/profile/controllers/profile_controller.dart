import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final ApiService apiService = ApiService();
  late final ProfileRepository profileRepository =
      ProfileRepository(apiService);
  late final AuthRepository authRepository = AuthRepository(apiService);
  Rx<Profile?> profile = Rx<Profile?>(null);
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ever<Profile?>(profile, (newProfile) {
        if (newProfile != null) {
          namaC.text = newProfile.user?.nama ?? '';
          emailC.text = newProfile.user?.email ?? '';
        }
      });
    });
    await fetchProfile();
    super.onInit();
  }

  @override
  void onClose() {
    namaC.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      profile.value = await profileRepository.getProfile();
    } catch (e, stackTrace) {
      print('Error fetching profile: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  Future<void> performLogout() async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
      );

      await Future.delayed(Duration(milliseconds: 800));
      deleteAuth();
      deleteisPregnant();
      await authRepository.logout();
      Get.offAllNamed(Routes.ONBOARDING);
    } catch (error) {
      print("Logout failed: $error");
      Get.back();
    }
  }

  void deleteAuth() {
    box.write("isAuth", false);
  }

  void deleteisPregnant() {
    box.remove("isPregnant");
  }
}
