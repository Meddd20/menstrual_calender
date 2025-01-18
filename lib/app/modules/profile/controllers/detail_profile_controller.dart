import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

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
    _profileService = ProfileService();
    _syncDataRepository = SyncDataRepository();

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
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;

    if (namaC.text != originalNama || birthdayC.text != originalBirthday) {
      try {
        await _profileService.updateProfile(namaC.text, formatDate(userBirthday.value!));
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.profileEditedSuccess));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.profileEditFailed));
        return;
      }

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await SyncDataService().pendingDataChange();
          await profileRepository.editProfile(namaC.text, birthdayC.text);
        } catch (e) {
          await _syncEditProfile(storageService.getAccountLocalId());
        }
      } else if (localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        await _syncEditProfile(storageService.getAccountLocalId());
      }

      Get.offAllNamed(Routes.NAVIGATION_MENU);
    } else {
      return;
    }
  }

  Future<void> _syncEditProfile(int user_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'user',
      operation: 'update',
      dataId: user_id,
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
