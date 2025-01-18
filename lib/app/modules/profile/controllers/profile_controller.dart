import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';
import 'package:periodnpregnancycalender/app/common/common.dart';

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
      await syncDataService.rebackupData();
    } else {
      await authRepository.deleteData();
    }

    storageService.storeIsBackup(backup);
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
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool remoteSuccess = false;
    var pregnancy;

    if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      pregnancy = await pregnancyRepository.pregnancyBegin(selectedDate!.toString(), null);
      remoteSuccess = true;
    }

    try {
      if (remoteSuccess && pregnancy["data"]["id"] != null) {
        await _pregnancyHistoryService.beginPregnancy(selectedDate!, pregnancy["data"]["id"]);
      } else {
        PregnancyHistory? addedPregnancy = await _pregnancyHistoryService.beginPregnancy(selectedDate!, null);
        await _syncPregnancyBegin(addedPregnancy?.id ?? 0);
      }

      storageService.storeIsPregnant("1");
      Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.pregnancyStartedSuccess));
      await Get.offAllNamed(Routes.NAVIGATION_MENU);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.pregnancyStartFailed));
      return;
    }
  }

  Future<void> _syncPregnancyBegin(int pregnancy_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'pregnancy',
      operation: 'create',
      dataId: pregnancy_id,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> performLogout() async {
    try {
      if (!storageService.getIsBackup()) {
        await syncDataService.rebackupData();
      }
      await Center(child: CircularProgressIndicator());
      await Future.delayed(Duration(milliseconds: 400));
      storageService.storeIsAuth(false);
      storageService.deleteCredentialToken();
      storageService.deleteIsPregnant();
      storageService.setHasSyncData(false);
      storageService.setPin(false);
      LocalNotificationService().cancelAllNotifications();
      storageService.deleteAccountLocalId();
      storageService.storeIsAccountCreatedUnverified(false);
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
    lastPregnancyHistory = pregnancyHistoryList?.last;
  }

  String get formattedStartDate => startDate.value != null ? formatDate(startDate.value!) : formatDate(DateTime.now());
  String get formattedEndDate => endDate.value != null ? formatDate(endDate.value!) : formatDate(DateTime.now());

  void addPeriod(context, int avgPeriodDuration, int avgPeriodCycle) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool remoteSuccess = false;
    var periodStoredRemote;

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

      if (isConnected && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        periodStoredRemote = await periodRepository.storePeriod(periods, avgPeriodCycle, null);
        remoteSuccess = true;
      }

      try {
        if (remoteSuccess) {
          await _periodHistoryService.addPeriod(
            periodStoredRemote?[0].id,
            DateTime.parse(formattedStartDate),
            DateTime.parse(formattedEndDate),
            avgPeriodCycle,
          );
        } else {
          PeriodHistory? addedPeriod = await _periodHistoryService.addPeriod(
            null,
            DateTime.parse(formattedStartDate),
            DateTime.parse(formattedEndDate),
            avgPeriodCycle,
          );
          await syncAddedPeriod(addedPeriod?.id ?? 0);
        }

        Get.showSnackbar(Ui.SuccessSnackBar(message: AppLocalizations.of(context)!.periodAddedSuccess));
        await Get.offAllNamed(Routes.NAVIGATION_MENU);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.periodAddFailed));
        return;
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: AppLocalizations.of(context)!.selectPeriodStartDate));
      return;
    }
  }

  Future<void> syncAddedPeriod(int period_id) async {
    SyncLog syncLog = SyncLog(
      tableName: 'period',
      operation: 'create',
      dataId: period_id,
      createdAt: DateTime.now().toString(),
    );

    await syncDataRepository.addSyncLogData(syncLog);
  }
}
