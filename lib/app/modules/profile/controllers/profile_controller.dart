import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/profile_repository.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/services/sync_data_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final ProfileRepository profileRepository = ProfileRepository(apiService);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final AuthRepository authRepository = AuthRepository(apiService);
  Rx<User?> profile = Rx<User?>(null);
  var radioGoalSelect = 0.obs;
  var periodStartDate = DateTime.now().obs;
  var birthDate = "".obs;
  var gender = "".obs;
  var firstDayLastPeriod = DateTime.now().obs;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  var purposeText = "".obs;
  var useLastPeriodData = true.obs;
  Rx<int?> selectedLanguage = Rx<int>(0);
  Rx<int?> syncPreferences = Rx<int>(0);
  Rx<bool?> isDataBackedup = Rx<bool>(false);
  RxBool setPin = false.obs;
  RxInt aboutAppIndex = 0.obs;

  late final Future<User?> profileUser;

  late final ProfileService profileService;
  late final SyncDataRepository syncDataRepository;
  late final PregnancyHistoryService _pregnancyHistoryService;
  late final SyncDataService syncDataService;

  @override
  void onInit() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final MasterDataKehamilanRepository masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);

    syncDataRepository = SyncDataRepository(databaseHelper);
    profileService = ProfileService(localProfileRepository);
    _pregnancyHistoryService = PregnancyHistoryService(
      pregnancyHistoryRepository,
      masterKehamilanRepository,
      periodHistoryRepository,
      localProfileRepository,
    );

    syncDataService = SyncDataService();
    profileUser = fetchProfile();
    usePurpose();

    if (storageService.getIsPregnant() == "1") {
      fetchPregnancyData();
    } else {
      HomeMenstruationController homeMenstruationController = Get.find<HomeMenstruationController>();
      setFocusedDate(homeMenstruationController.haidAwalList.first);
      setSelectedDate(homeMenstruationController.haidAwalList.first);
    }
    selectedLanguage.value = storageService.getLanguage() == "en" ? 0 : 1;
    // syncPreferences.value = storageService.getStoreDataMechanism() == "primary" ? 0 : 1;
    isDataBackedup.value = storageService.getIsBackup();
    setPin.value = storageService.isPinSecure();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final Rx<DateTime> _focusedDate = Rx<DateTime>(DateTime.now());
  DateTime get getFocusedDate => _focusedDate.value;

  void setFocusedDate(DateTime selectedDate) {
    _focusedDate.value = selectedDate;
    update();
  }

  final Rx<DateTime?> _selectedDate = Rx<DateTime?>(DateTime.now());

  DateTime? get selectedDate => _selectedDate.value;

  void setSelectedDate(DateTime selectedDate) {
    _selectedDate.value = selectedDate;
    update();
  }

  void setSelectedLanguage(int value) {
    selectedLanguage.value = value;
    update();
  }

  void setLanguage() {
    if (selectedLanguage.value == 0) {
      storageService.setLanguage("en");
      Get.updateLocale(Locale("en"));
    } else {
      storageService.setLanguage("id");
      Get.updateLocale(Locale("id"));
    }
    Get.offAllNamed(Routes.NAVIGATION_MENU);
  }

  void setSelectedSyncPreferences(int value) {
    syncPreferences.value = value;
    update();
  }

  Future<void> _handleDataBackup(bool backup) async {
    isDataBackedup.value = backup;

    if (backup) {
      syncDataService.rebackupData();
    } else {
      authRepository.deleteData();
    }

    storageService.storeIsBackup(backup);
    update();

    await Future.delayed(Duration(milliseconds: 350));
    Get.offAllNamed(Routes.NAVIGATION_MENU);
  }

  Future<void> unbackupData() async {
    await _handleDataBackup(false);
  }

  Future<void> rebackupData() async {
    await _handleDataBackup(true);
  }

  // Future<void> fetchProfile() async {
  //   profile.value = await profileRepository.getProfile();
  // }

  Future<User?> fetchProfile() async {
    User? user = await profileService.getProfile();
    birthDate.value = user!.tanggalLahir!;
    print(birthDate.value);
    return user;
  }

  void startPregnancy(context) async {
    bool remoteSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    var pregnancy;
    if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        pregnancy = await pregnancyRepository.pregnancyBegin(selectedDate!.toString(), null);
        remoteSuccess = true;
      } catch (e) {
        await _syncPregnancyBegin();
      }
    } else {
      await _syncPregnancyBegin();
    }

    try {
      if (remoteSuccess) {
        await _pregnancyHistoryService.beginPregnancy(selectedDate!, pregnancy["data"]["id"]);
      } else {
        await _pregnancyHistoryService.beginPregnancy(selectedDate!, null);
        await _syncPregnancyBegin();
      }

      storageService.storeIsPregnant("1");
      Get.offAllNamed(Routes.NAVIGATION_MENU);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyStartedSuccess));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyStartFailed));
    }
  }

  Future<void> _syncPregnancyBegin() async {
    Map<String, dynamic> data = {
      "firstDayLastMenstruation": selectedDate.toString(),
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'beginPregnancy',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> endPregnancy(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    try {
      await _pregnancyHistoryService.endPregnancy(selectedDate!, gender.value);
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyEndedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyEndFailed));
    }

    storageService.storeIsPregnant("0");
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.pregnancyEnded(selectedDate.toString(), gender.value);
      } catch (e) {
        await _syncPregnancyEnded();
      }
    } else if (localSuccess) {
      await _syncPregnancyEnded();
    }
  }

  Future<void> _syncPregnancyEnded() async {
    Map<String, dynamic> data = {
      "pregnancyEndDate": selectedDate.toString(),
      "gender": gender.value,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'endPregnancy',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancy(context) async {
    bool localSuccess = false;
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    try {
      await _pregnancyHistoryService.deletePregnancy();
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyDeletedSuccess));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyDeleteFailed));
    }

    storageService.storeIsPregnant("0");
    LocalNotificationService().cancelAllPregnancyNotifications(storageService.getAccountLocalId());
    Get.offAllNamed(Routes.NAVIGATION_MENU);

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await pregnancyRepository.deletePregnancy();
      } catch (e) {
        await _syncPregnancyDelete();
      }
    } else if (localSuccess) {
      await _syncPregnancyDelete();
    }
  }

  Future<void> _syncPregnancyDelete() async {
    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'deletePregnancy',
      data: '{}',
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> performLogout() async {
    try {
      await Center(child: CircularProgressIndicator());
      await Future.delayed(Duration(milliseconds: 400));
      storageService.storeIsAuth(false);
      storageService.deleteCredentialToken();
      storageService.deleteIsPregnant();
      storageService.setHasSyncData(false);
      storageService.setPin(false);
      LocalNotificationService().cancelAllNotifications();
      storageService.deleteAccountLocalId();
      // await profileService.deleteProfile();
      await profileService.deletePendingDataChanges();
      await authRepository.logout();
      Get.offAllNamed(Routes.ONBOARDING);
    } catch (error) {
      print("Logout failed: $error");
      Get.back();
    }
  }

  int get getRadioGoalSelect => radioGoalSelect.value;

  void setRadioGoalSelect(int value) {
    radioGoalSelect.value = value;
  }

  void usePurpose() {
    var isPregnantString = storageService.getIsPregnant();
    if (isPregnantString != null) {
      var isPregnantInt = int.tryParse(isPregnantString);
      if (isPregnantInt != null) {
        setRadioGoalSelect(isPregnantInt);
        if (isPregnantInt == 0) {
          purposeText.value = "Tracking Menstrual Period";
        } else {
          purposeText.value = "Follow Pregnancy";
        }
      }
    }
  }

  RxList<DateTime> tanggalAwalMinggu = <DateTime>[].obs;
  RxList<DateTime> tanggalAkhirMinggu = <DateTime>[].obs;

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData(storageService.getLanguage());
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);

    for (var entry in weeklyData) {
      if (entry.tanggalAwalMinggu != null) {
        DateTime parsedDate = formatDateStr(entry.tanggalAwalMinggu!);
        tanggalAwalMinggu.add(parsedDate);
      }
      if (entry.tanggalAkhirMinggu != null) {
        DateTime parsedDate = formatDateStr(entry.tanggalAkhirMinggu!);
        tanggalAkhirMinggu.add(parsedDate);
      }
    }

    update();
  }

  List<String> aboutAppInfo(BuildContext context) {
    return [
      AppLocalizations.of(context)!.aboutAppInfo,
      AppLocalizations.of(context)!.creditToFlaticon,
      AppLocalizations.of(context)!.creditToBabyCenter,
      AppLocalizations.of(context)!.creditToWhatToExpect,
    ];
  }

  void aboutAppIndexBackward() {
    if (aboutAppIndex.value > 0) {
      aboutAppIndex.value--;
    }
  }

  void aboutAppIndexForward() {
    if (aboutAppIndex.value < aboutAppInfo(Get.context!).length - 1) {
      aboutAppIndex.value++;
    }
  }

  void resetValuePregnancy() {
    gender.value = "";
    setSelectedDate(DateTime.now());
  }

  void setPinSecure(bool isPinSecure) {
    setPin.value = isPinSecure;
    storageService.setPin(isPinSecure);
  }
}
