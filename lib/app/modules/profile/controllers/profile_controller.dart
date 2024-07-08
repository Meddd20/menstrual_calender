import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/profile_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class ProfileController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late final ProfileRepository profileRepository = ProfileRepository(apiService, databaseHelper);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final AuthRepository authRepository = AuthRepository(apiService);
  Rx<User?> profile = Rx<User?>(null);
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  var radioGoalSelect = 0.obs;
  var periodStartDate = DateTime.now().obs;
  var birthDate = DateTime.now().obs;
  var gender = "".obs;
  var firstDayLastPeriod = DateTime.now().obs;
  Rx<CurrentlyPregnant> currentlyPregnantData = Rx<CurrentlyPregnant>(CurrentlyPregnant());
  RxList<WeeklyData> weeklyData = <WeeklyData>[].obs;
  var purposeText = "".obs;
  var useLastPeriodData = true.obs;
  late final ProfileService _profileService;
  late final SyncDataRepository _syncDataRepository;
  late final PregnancyHistoryService _pregnancyHistoryService;

  @override
  void onInit() async {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ever<Profile?>(profile, (newProfile) {
    //     if (newProfile != null) {
    //       namaC.text = newProfile.userData!.user!.nama ?? '';
    //       emailC.text = newProfile.userData!.user!.email ?? '';
    //     }
    //   });
    // });
    fetchProfile();
    usePurpose();
    if (storageService.getIsPregnant() == "1") {
      fetchPregnancyData();
    } else {
      HomeMenstruationController homeMenstruationController = Get.find<HomeMenstruationController>();
      setFocusedDate(homeMenstruationController.haidAwalList.last);
      setSelectedDate(homeMenstruationController.haidAwalList.last);
    }

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final LocalProfileRepository localProfileRepository = LocalProfileRepository(databaseHelper);
    final PregnancyHistoryRepository pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
    final MasterKehamilanRepository masterKehamilanRepository = MasterKehamilanRepository(databaseHelper);
    final PeriodHistoryRepository periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
    _syncDataRepository = SyncDataRepository(databaseHelper);
    _profileService = ProfileService(localProfileRepository);
    _pregnancyHistoryService = PregnancyHistoryService(pregnancyHistoryRepository, masterKehamilanRepository, periodHistoryRepository, localProfileRepository);

    super.onInit();
  }

  @override
  void onClose() {
    namaC.dispose();
    super.onClose();
  }

  // Future<void> fetchProfile() async {
  //   profile.value = await profileRepository.getProfile();
  // }

  Future<void> fetchProfile() async {
    profile.value = await _profileService.getProfile();
  }

  Future<void> startPregnancy() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    _pregnancyHistoryService.beginPregnancy(selectedDate!);

    if (storageService.getIsAuth() && !isConnected) {
      await _syncPregnancyBegin();
      return;
    }

    try {
      await pregnancyRepository.pregnancyBegin(selectedDate.toString(), null);
      Get.offAllNamed(Routes.NAVIGATION_MENU);
      storageService.storeIsPregnant("1");
    } catch (e) {
      print("Error editing pregnancy start date: $e");
      _syncPregnancyBegin();
    }
  }

  Future<void> _syncPregnancyBegin() async {
    Map<String, dynamic> data = {
      "hari_pertama_haid_terakhir": selectedDate,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'beginPregnancy',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> endPregnancy() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    _pregnancyHistoryService.endPregnancy(selectedDate!, gender.value);

    if (storageService.getIsAuth() && !isConnected) {
      await _syncPregnancyEnded();
      return;
    }

    try {
      await pregnancyRepository.pregnancyEnded(selectedDate.toString(), gender.value);
      Get.offAllNamed(Routes.NAVIGATION_MENU);
      storageService.storeIsPregnant("0");
    } catch (e) {
      print("Error editing pregnancy start date: $e");
      _syncPregnancyEnded();
    }
  }

  Future<void> _syncPregnancyEnded() async {
    Map<String, dynamic> data = {
      "pregnancy_end": selectedDate,
      "gender": gender.value,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'endPregnancy',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deletePregnancy() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    _pregnancyHistoryService.deletePregnancy();

    if (storageService.getIsAuth() && !isConnected) {
      await _syncPregnancyDelete();
      return;
    }

    try {
      await pregnancyRepository.deletePregnancy();
      Get.offAllNamed(Routes.NAVIGATION_MENU);
      storageService.storeIsPregnant("0");
    } catch (e) {
      print("Error editing pregnancy start date: $e");
      _syncPregnancyDelete();
    }
  }

  Future<void> _syncPregnancyDelete() async {
    SyncLog syncLog = SyncLog(
      tableName: 'tb_riwayat_kehamilan',
      operation: 'deletePregnancy',
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> performLogout() async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
      );

      await Future.delayed(Duration(milliseconds: 400));
      storageService.storeIsAuth(false);
      storageService.deleteCredentialToken();
      storageService.deleteIsPregnant();
      await _profileService.deleteProfile();
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

  // Future<void> fetchPregnancyData() async {
  //   var result = await pregnancyRepository.getPregnancyIndex();
  //   currentlyPregnantData.value = result!.data!.currentlyPregnant!.first;
  //   weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);

  //   DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  //   for (var entry in weeklyData) {
  //     if (entry.tanggalAwalMinggu != null) {
  //       DateTime parsedDate = dateFormat.parse(entry.tanggalAwalMinggu!);
  //       tanggalAwalMinggu.add(parsedDate);
  //     }
  //     if (entry.tanggalAkhirMinggu != null) {
  //       DateTime parsedDate = dateFormat.parse(entry.tanggalAkhirMinggu!);
  //       tanggalAkhirMinggu.add(parsedDate);
  //     }
  //   }

  //   update();
  // }

  Future<void> fetchPregnancyData() async {
    var result = await _pregnancyHistoryService.getCurrentPregnancyData("id");
    currentlyPregnantData.value = result!;
    weeklyData.assignAll(currentlyPregnantData.value.weeklyData!);

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    for (var entry in weeklyData) {
      if (entry.tanggalAwalMinggu != null) {
        DateTime parsedDate = dateFormat.parse(entry.tanggalAwalMinggu!);
        tanggalAwalMinggu.add(parsedDate);
      }
      if (entry.tanggalAkhirMinggu != null) {
        DateTime parsedDate = dateFormat.parse(entry.tanggalAkhirMinggu!);
        tanggalAkhirMinggu.add(parsedDate);
      }
    }

    update();
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

  void resetValuePregnancy() {
    gender.value = "";
    setSelectedDate(DateTime.now());
  }
}
