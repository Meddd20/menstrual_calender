import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/period_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/auth_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/profile_repository.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/services/sync_data_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final ProfileRepository profileRepository = ProfileRepository(apiService);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late final AuthRepository authRepository = AuthRepository(apiService);
  Rx<User?> profile = Rx<User?>(null);
  var radioGoalSelect = 0.obs;
  var periodStartDate = DateTime.now().obs;
  var birthDate = "".obs;
  var firstDayLastPeriod = DateTime.now().obs;
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
  late final PeriodHistoryService _periodHistoryService;
  late final SyncDataService syncDataService;

  late List<Map<String, dynamic>> periods = [];
  Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void setStartDate(DateTime? date) {
    startDate.value = date;
    print(startDate);
  }

  void setEndDate(DateTime? date) {
    endDate.value = date;
    print(endDate);
  }

  @override
  void onInit() async {
    syncDataRepository = SyncDataRepository();
    profileService = ProfileService();
    _pregnancyHistoryService = PregnancyHistoryService();
    _periodHistoryService = PeriodHistoryService();

    syncDataService = SyncDataService();
    profileUser = fetchProfile();
    usePurpose();

    if (storageService.getIsPregnant() == "0") {
      HomeMenstruationController homeMenstruationController = Get.find<HomeMenstruationController>();
      setFocusedDate(homeMenstruationController.haidAwalList.first);
      setSelectedDate(homeMenstruationController.haidAwalList.first);
    }
    radioGoalSelect.value = storageService.getIsPregnant() == "0" ? 0 : 1;
    selectedLanguage.value = storageService.getLanguage() == "en" ? 0 : 1;
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

  Future<User?> fetchProfile() async {
    User? user = await profileService.getProfile();
    birthDate.value = user!.tanggalLahir!;
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
    if (isPregnantString.isNotEmpty) {
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

  void setPinSecure(bool isPinSecure) {
    setPin.value = isPinSecure;
    storageService.setPin(isPinSecure);
  }

  void cancelEdit() {
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }

  PregnancyHistory? lastPregnancyHistory;

  Future<void> getAllPregnancyHistory() async {
    List<PregnancyHistory>? pregnancyHistoryList = await _pregnancyHistoryService.getAllPregnancyHistory();
    print("this is last pregnancy${pregnancyHistoryList?.last}");
    lastPregnancyHistory = pregnancyHistoryList?.last;
  }

  String get formattedStartDate => startDate.value != null ? formatDate(startDate.value!) : formatDate(DateTime.now());
  String get formattedEndDate => endDate.value != null ? formatDate(endDate.value!) : formatDate(DateTime.now());

  void addPeriod(context, int avgPeriodDuration, int avgPeriodCycle) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();

    if (startDate.value != null) {
      if (formattedStartDate == formattedEndDate || endDate.value == null) {
        setEndDate(startDate.value!.add(Duration(days: avgPeriodDuration)));
      }

      periods = [
        {
          'first_period': formattedStartDate,
          'last_period': formattedEndDate,
        }
      ];

      var newPeriod;
      if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          newPeriod = await periodRepository.storePeriod(periods, avgPeriodCycle, null);
        } catch (e) {
          await syncAddedPeriod(periods, avgPeriodCycle);
        }
      } else {
        await syncAddedPeriod(periods, avgPeriodCycle);
      }

      try {
        await _periodHistoryService.addPeriod(newPeriod?[0].id ?? null, DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), avgPeriodCycle);
        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.periodAddedSuccess));
        Get.offAllNamed(Routes.NAVIGATION_MENU);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodAddFailed));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.selectPeriodStartDate));
    }
  }

  Future<void> syncAddedPeriod(List<Map<String, dynamic>> periods, int periodCycle) async {
    Map<String, dynamic> data = {
      "periods": periods,
      "periodCycle": periodCycle,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_mens',
      operation: 'addPeriod',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }
}
