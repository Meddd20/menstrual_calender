import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailprofileController extends GetxController {
  late User? userProfile;
  late String originalNama;
  late String originalBirthday;
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController birthdayC = TextEditingController();
  Rx<DateTime?> userBirthday = Rx<DateTime?>(null);
  Rx<bool> isChanged = Rx<bool>(false);

  final ApiService apiService = ApiService();
  late final ProfileRepository profileRepository = ProfileRepository(apiService);
  late final ProfileService _profileService;
  late final SyncDataRepository _syncDataRepository;
  final StorageService storageService = StorageService();

  @override
  void onInit() {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    _profileService = ProfileService(localProfileRepository);
    _syncDataRepository = SyncDataRepository(databaseHelper);

    namaC = TextEditingController();
    emailC = TextEditingController();
    birthdayC = TextEditingController();

    userProfile = Get.arguments as User?;
    originalNama = userProfile!.nama!;
    if (userProfile?.tanggalLahir != null) {
      originalBirthday = userProfile!.tanggalLahir!;
      birthdayC.text = formatYearMonthDay(userProfile!.tanggalLahir!);
      userBirthday.value = DateTime.parse(originalBirthday);
    }

    namaC.text = userProfile!.nama!;
    emailC.text = userProfile?.email ?? "N/A";

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() async {
    super.onClose();
    await _profileService.getProfile();
    namaC.dispose();
    emailC.dispose();
    birthdayC.dispose();
  }

  void setEditedBirthday() {
    birthdayC.text = formatDate(userBirthday.value!);
    isChanged.value = true;
  }

  void updateProfile(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    if (namaC.text != originalNama || birthdayC.text != originalBirthday) {
      try {
        await _profileService.updateProfile(namaC.text, formatDate(userBirthday.value!));
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.profileEditedSuccess));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.profileEditFailed));
      }

      Get.offAllNamed(Routes.NAVIGATION_MENU);

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await profileRepository.editProfile(namaC.text, birthdayC.text);
        } catch (e) {
          await _syncEditProfile();
        }
      } else if (localSuccess) {
        await _syncEditProfile();
      }
    } else {
      return;
    }
  }

  Future<void> _syncEditProfile() async {
    Map<String, dynamic> data = {
      "nama": namaC.text,
      "tanggalLahir": birthdayC.text,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_user',
      operation: 'updateProfile',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  String getInitials(String username) {
    List<String> nameParts = username.split(" ");

    if (nameParts.length > 1) {
      return nameParts[0][0].toLowerCase() + nameParts[1][0].toLowerCase();
    } else if (nameParts.isNotEmpty) {
      return username.substring(0, 2).toLowerCase();
    }

    return "";
  }
}
