import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/master_data_version_model.dart';
import 'package:periodnpregnancycalender/app/models/master_food_model.dart';
import 'package:periodnpregnancycalender/app/models/master_pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/master_vaccines_model.dart';
import 'package:periodnpregnancycalender/app/models/master_vitamins_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_data_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/master_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/period_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_food_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_gender_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_kehamilan_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_newmoon_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_vaccines_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/master_vitamins_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/weight_history_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/services/master_food_service.dart';
import 'package:periodnpregnancycalender/app/services/master_kehamilan_service.dart';
import 'package:periodnpregnancycalender/app/services/master_vaccines_service.dart';
import 'package:periodnpregnancycalender/app/services/master_vitamins_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_log_service.dart';
import 'package:periodnpregnancycalender/app/services/weight_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class SyncDataService {
  final StorageService storageService = StorageService();
  final Logger _logger = Logger();

  final ApiService apiService = ApiService();
  late final ProfileRepository profileRepository = ProfileRepository(apiService);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late final LogRepository logRepository = LogRepository(apiService);
  late final MasterDataRepository masterDataRepository = MasterDataRepository(apiService);
  late final PregnancyLogAPIRepository pregnancyLogAPIRepository = PregnancyLogAPIRepository(apiService);

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late final PeriodHistoryRepository _periodHistoryRepository = PeriodHistoryRepository(databaseHelper);
  late final PregnancyHistoryRepository _pregnancyHistoryRepository = PregnancyHistoryRepository(databaseHelper);
  late final WeightHistoryRepository _weightHistoryRepository = WeightHistoryRepository(databaseHelper);
  late final LocalProfileRepository _localProfileRepository = LocalProfileRepository(databaseHelper);
  late final SyncDataRepository _syncDataRepository = SyncDataRepository(databaseHelper);
  late final LocalLogRepository _localLogRepository = LocalLogRepository(databaseHelper);
  late final MasterNewmoonRepository _masterNewmoonRepository = MasterNewmoonRepository(databaseHelper);
  late final MasterGenderRepository _masterGenderRepository = MasterGenderRepository(databaseHelper);
  late final MasterDataKehamilanRepository _masterKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
  late final MasterFoodRepository masterFoodRepository = MasterFoodRepository(databaseHelper);
  late final MasterDataKehamilanRepository masterDataKehamilanRepository = MasterDataKehamilanRepository(databaseHelper);
  late final MasterVaccinesRepository masterVaccinesRepository = MasterVaccinesRepository(databaseHelper);
  late final MasterVitaminsRepository masterVitaminsRepository = MasterVitaminsRepository(databaseHelper);
  late final PregnancyLogRepository pregnancyLogRepository = PregnancyLogRepository(databaseHelper);

  late final PeriodHistoryService periodHistoryService = PeriodHistoryService(_periodHistoryRepository, _localProfileRepository, _masterNewmoonRepository, _masterGenderRepository);
  late final PregnancyHistoryService pregnancyHistoryService = PregnancyHistoryService(_pregnancyHistoryRepository, _masterKehamilanRepository, _periodHistoryRepository, _localProfileRepository);
  late final WeightHistoryService weightHistoryService = WeightHistoryService(_weightHistoryRepository, _pregnancyHistoryRepository);
  late final LogService logService = LogService(_localLogRepository);
  late final MasterFoodService masterFoodService = MasterFoodService(masterFoodRepository);
  late final MasterKehamilanService masterKehamilanService = MasterKehamilanService(masterDataKehamilanRepository);
  late final MasterVaccinesService masterVaccinesService = MasterVaccinesService(masterVaccinesRepository);
  late final MasterVitaminsService masterVitaminsService = MasterVitaminsService(masterVitaminsRepository);
  late final PregnancyLogService pregnancyLogService = PregnancyLogService(pregnancyLogRepository, _pregnancyHistoryRepository);

  Future<void> syncData() async {
    try {
      int userId = storageService.getAccountLocalId();
      User? profile = await _localProfileRepository.getProfile();
      DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);
      List<PeriodHistory>? periodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PregnancyHistory>? pregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
      List<WeightHistory>? weightHistory = await _weightHistoryRepository.getWeightHistory(userId);
      List<PregnancyDailyLog>? pregnancyDailyLog = await pregnancyLogRepository.getAllPregnancyDailyLog(userId);

      DataCategoryByTable? dataFetchFromAPI = await profileRepository.fetchSyncDataFromApi();
      User? profileFetchFromAPI = dataFetchFromAPI?.user;
      DailyLogss? dailyLogFetchFromAPI = dataFetchFromAPI?.logHistory;
      List<PeriodHistory>? periodHistoryFetchFromAPI = dataFetchFromAPI?.periodHistory;
      PregnancyHistory? pregnancyHistoryFetchFromAPI = dataFetchFromAPI?.pregnancyHistory;
      List<WeightHistory>? weightHistoryFetchFromAPI = dataFetchFromAPI?.weightGainHistory;
      List<MasterDataVersion>? masterDataVersion = dataFetchFromAPI?.masterDataVersion;
      PregnancyDailyLog? pregnancyDailyLogFetchFromAPI = dataFetchFromAPI?.pregnancyDailyLog;

      await _syncUserData(profile, profileFetchFromAPI, userId);
      await _syncDailyLogData(dailyLog, dailyLogFetchFromAPI, userId);
      await _syncPeriodHistoryData(periodHistory, periodHistoryFetchFromAPI, userId);
      await _syncPregnancyHistoryData(pregnancyHistory, pregnancyHistoryFetchFromAPI, userId);
      await _syncPregnancyDailyLogData(pregnancyDailyLog, pregnancyDailyLogFetchFromAPI, userId);
      await _syncWeightHistoryData(weightHistory, weightHistoryFetchFromAPI, userId);
      await _syncMasterDataVersion(masterDataVersion);
    } catch (e) {
      _logger.e("Error during sync data: $e");
      throw Exception('Data tidak lengkap');
    }
  }

  Future<void> _syncUserData(User? profile, User? profileFetchFromAPI, int userId) async {
    if (profileFetchFromAPI != null && profile != null) {
      if (profileFetchFromAPI.nama != profile.nama || profileFetchFromAPI.tanggalLahir != profile.tanggalLahir || profileFetchFromAPI.isPregnant != profile.isPregnant || profileFetchFromAPI.email != profile.email) {
        User syncUserProfile = User(
          nama: profileFetchFromAPI.nama,
          email: profileFetchFromAPI.email,
          tanggalLahir: profileFetchFromAPI.tanggalLahir,
          isPregnant: profileFetchFromAPI.isPregnant,
        );
        await _localProfileRepository.updateProfile(syncUserProfile);
      }
    }
  }

  Future<void> _syncDailyLogData(DailyLog? localDailyLog, DailyLogss? fetchedDailyLog, int userId) async {
    List<DataHarian>? localDataHarian = localDailyLog?.dataHarian;
    List<Reminders>? localReminders = localDailyLog?.pengingat;
    Map<String, DataHarian>? fetchedDataHarian = fetchedDailyLog?.dataHarian;
    List<Reminders>? fetchedReminders = fetchedDailyLog?.pengingat;

    if (fetchedDailyLog != null) {
      if (localDataHarian != null && localReminders != null) {
        if (fetchedDataHarian != null) {
          Set<String> fetchedDates = fetchedDataHarian.keys.toSet();
          for (var localData in localDataHarian) {
            if (localData.date != null && !fetchedDates.contains(localData.date!)) {
              await logService.deleteDailyLog(localData.date!);
            }
          }

          for (var entry in fetchedDataHarian.entries) {
            DataHarian fetchedData = entry.value;
            await logService.upsertDailyLog(
              fetchedData.date ?? "",
              fetchedData.sexActivity,
              fetchedData.bleedingFlow,
              fetchedData.symptoms?.toJson(),
              fetchedData.vaginalDischarge,
              fetchedData.moods?.toJson(),
              fetchedData.others?.toJson(),
              fetchedData.physicalActivity?.toJson(),
              fetchedData.temperature,
              fetchedData.weight,
              fetchedData.notes,
            );
          }
        }

        // Sync Reminders
        if (fetchedReminders != null) {
          List<int> notFoundInLocal = [];

          for (var i = 0; i < fetchedReminders.length; i++) {
            bool foundMatch = false;

            for (var localReminder in localReminders) {
              if (localReminder.id == fetchedReminders[i].id && localReminder.title == fetchedReminders[i].title && localReminder.datetime == fetchedReminders[i].datetime && localReminder.description == fetchedReminders[i].description) {
                foundMatch = true;
                break;
              }
            }

            if (!foundMatch) {
              notFoundInLocal.add(i);
            }
          }

          for (var localReminder in localReminders) {
            bool foundInApi = false;

            for (var fetchedReminder in fetchedReminders) {
              if (localReminder.id == fetchedReminder.id && localReminder.title == fetchedReminder.title && localReminder.datetime == fetchedReminder.datetime && localReminder.description == fetchedReminder.description) {
                foundInApi = true;
                break;
              }
            }

            if (!foundInApi) {
              await logService.deleteReminder(localReminder.id!);
            }
          }

          for (var index in notFoundInLocal) {
            Reminders newReminder = Reminders(
              id: fetchedReminders[index].id ?? "",
              title: fetchedReminders[index].title,
              description: fetchedReminders[index].description,
              datetime: fetchedReminders[index].datetime,
            );
            await logService.addReminder(newReminder);
          }
        }
      } else {
        // Sync DataHarian jika localDataHarian kosong
        if (fetchedDataHarian != null) {
          for (var entry in fetchedDataHarian.entries) {
            DataHarian fetchedData = entry.value;
            await logService.upsertDailyLog(
              fetchedData.date ?? "",
              fetchedData.sexActivity,
              fetchedData.bleedingFlow,
              fetchedData.symptoms?.toJson(),
              fetchedData.vaginalDischarge,
              fetchedData.moods?.toJson(),
              fetchedData.others?.toJson(),
              fetchedData.physicalActivity?.toJson(),
              fetchedData.temperature,
              fetchedData.weight,
              fetchedData.notes,
            );
          }
        }

        // Sync Reminders jika localReminders kosong
        if (fetchedReminders != null) {
          for (var fetchedReminder in fetchedReminders) {
            Reminders newReminder = Reminders(
              id: fetchedReminder.id,
              title: fetchedReminder.title,
              description: fetchedReminder.description,
              datetime: fetchedReminder.datetime,
            );
            await logService.addReminder(newReminder);
          }
        }
      }
    }
  }

  Future<void> _syncPeriodHistoryData(List<PeriodHistory>? periodHistory, List<PeriodHistory>? periodHistoryFetchFromAPI, int userId) async {
    if (periodHistoryFetchFromAPI != null) {
      List<PeriodHistory>? isActualPeriodHistory = periodHistory?.where((period) => period.isActual == "1").toList() ?? [];
      List<PeriodHistory>? isActualPeriodHistoryFromAPI = periodHistoryFetchFromAPI.where((period) => period.isActual == "1").toList();

      if (isActualPeriodHistory.isEmpty) {
        // Jika data lokal kosong, sinkronkan semua data dari API
        for (var periodHistory in isActualPeriodHistoryFromAPI) {
          try {
            if (periodHistory.id != null && periodHistory.haidAwal != null && periodHistory.haidAkhir != null) {
              await periodHistoryService.addPeriod(
                periodHistory.id,
                periodHistory.haidAwal!,
                periodHistory.haidAkhir!,
                periodHistory.lamaSiklus,
              );
            }
          } catch (e) {
            // Log the error and continue with the next iteration
            print("Error processing periodHistory with id ${periodHistory.id}: $e");
          }
        }
      } else {
        // Jika panjang data tidak sama atau sama, lakukan sinkronisasi dengan API
        List<int> notFoundInLocal = [];

        for (var i = 0; i < isActualPeriodHistoryFromAPI.length; i++) {
          bool foundMatch = false;

          for (var j = 0; j < isActualPeriodHistory.length; j++) {
            if (isActualPeriodHistory[j].haidAwal == isActualPeriodHistoryFromAPI[i].haidAwal && isActualPeriodHistory[j].haidAkhir == isActualPeriodHistoryFromAPI[i].haidAkhir) {
              foundMatch = true;
              break;
            }
          }

          if (!foundMatch) {
            notFoundInLocal.add(i);
          }
        }

        for (var j = 0; j < isActualPeriodHistory.length; j++) {
          bool foundInApi = false;

          for (var i = 0; i < isActualPeriodHistoryFromAPI.length; i++) {
            if (isActualPeriodHistory[j].haidAwal == isActualPeriodHistoryFromAPI[i].haidAwal && isActualPeriodHistory[j].haidAkhir == isActualPeriodHistoryFromAPI[i].haidAkhir) {
              foundInApi = true;
              break;
            }
          }

          if (!foundInApi) {
            await _periodHistoryRepository.deletePeriodHistory(isActualPeriodHistory[j].id!, userId);
          }
        }

        for (var index in notFoundInLocal) {
          await periodHistoryService.addPeriod(
            isActualPeriodHistoryFromAPI[index].id,
            isActualPeriodHistoryFromAPI[index].haidAwal!,
            isActualPeriodHistoryFromAPI[index].haidAkhir!,
            isActualPeriodHistoryFromAPI[index].lamaSiklus,
          );
        }
      }
    }
  }

  Future<void> _syncPregnancyHistoryData(List<PregnancyHistory>? pregnancyHistory, PregnancyHistory? pregnancyHistoryFetchFromAPI, int userId) async {
    if (pregnancyHistoryFetchFromAPI != null) {
      if (pregnancyHistory == null || pregnancyHistory.isEmpty) {
        await _syncDataRepository.fetchNewlySyncPregnancyHistoryData(pregnancyHistoryFetchFromAPI, userId);
      } else {
        bool foundMatch = false;

        for (var localPregnancyData in pregnancyHistory) {
          if (localPregnancyData.status == pregnancyHistoryFetchFromAPI.status &&
              localPregnancyData.hariPertamaHaidTerakhir == pregnancyHistoryFetchFromAPI.hariPertamaHaidTerakhir &&
              localPregnancyData.kehamilanAkhir == pregnancyHistoryFetchFromAPI.kehamilanAkhir &&
              localPregnancyData.tinggiBadan == pregnancyHistoryFetchFromAPI.tinggiBadan &&
              localPregnancyData.beratPrakehamilan == pregnancyHistoryFetchFromAPI.beratPrakehamilan &&
              localPregnancyData.gender == pregnancyHistoryFetchFromAPI.gender &&
              localPregnancyData.isTwin == pregnancyHistoryFetchFromAPI.isTwin) {
            foundMatch = true;
          }
        }

        if (!foundMatch) {
          await _pregnancyHistoryRepository.addPregnancyData(
            pregnancyHistoryFetchFromAPI,
            userId,
            remoteId: pregnancyHistoryFetchFromAPI.id,
          );
        }

        for (var localPregnancyData in pregnancyHistory) {
          if (localPregnancyData.status != pregnancyHistoryFetchFromAPI.status &&
              localPregnancyData.hariPertamaHaidTerakhir != pregnancyHistoryFetchFromAPI.hariPertamaHaidTerakhir &&
              localPregnancyData.kehamilanAkhir != pregnancyHistoryFetchFromAPI.kehamilanAkhir &&
              localPregnancyData.tinggiBadan != pregnancyHistoryFetchFromAPI.tinggiBadan &&
              localPregnancyData.beratPrakehamilan != pregnancyHistoryFetchFromAPI.beratPrakehamilan &&
              localPregnancyData.gender != pregnancyHistoryFetchFromAPI.gender &&
              localPregnancyData.isTwin != pregnancyHistoryFetchFromAPI.isTwin) {
            await _pregnancyHistoryRepository.deletePregnancy(localPregnancyData.id!);
          }
        }
      }
    }
  }

  Future<void> _syncWeightHistoryData(List<WeightHistory>? weightHistory, List<WeightHistory>? weightHistoryFetchFromAPI, int userId) async {
    if (weightHistoryFetchFromAPI != null) {
      if (weightHistory == null || weightHistory.isEmpty) {
        await _syncDataRepository.fetchNewlySyncWeightGainHistoryData(weightHistoryFetchFromAPI, userId);
      } else {
        List<int> notFoundInLocal = [];

        for (var i = 0; i < weightHistoryFetchFromAPI.length; i++) {
          bool foundMatch = false;

          for (var j = 0; j < weightHistory.length; j++) {
            if (weightHistory[j].beratBadan == weightHistoryFetchFromAPI[i].beratBadan && weightHistory[j].mingguKehamilan == weightHistoryFetchFromAPI[i].mingguKehamilan && weightHistory[j].tanggalPencatatan == weightHistoryFetchFromAPI[i].tanggalPencatatan) {
              foundMatch = true;
              break;
            }
          }

          if (!foundMatch) {
            notFoundInLocal.add(i);
          }
        }

        for (var j = 0; j < weightHistory.length; j++) {
          bool foundInApi = false;

          for (var i = 0; i < weightHistoryFetchFromAPI.length; i++) {
            if (weightHistory[j].beratBadan == weightHistoryFetchFromAPI[i].beratBadan && weightHistory[j].mingguKehamilan == weightHistoryFetchFromAPI[i].mingguKehamilan && weightHistory[j].tanggalPencatatan == weightHistoryFetchFromAPI[i].tanggalPencatatan) {
              foundInApi = true;
              break;
            }
          }

          if (!foundInApi) {
            await _weightHistoryRepository.deleteWeightHistory(weightHistory[j].tanggalPencatatan!, userId);
          }
        }

        for (var index in notFoundInLocal) {
          await weightHistoryService.syncWeeklyWeightGain(WeightHistory(
            riwayatKehamilanId: weightHistoryFetchFromAPI[index].riwayatKehamilanId,
            beratBadan: weightHistoryFetchFromAPI[index].beratBadan,
            mingguKehamilan: weightHistoryFetchFromAPI[index].mingguKehamilan,
            tanggalPencatatan: weightHistoryFetchFromAPI[index].tanggalPencatatan,
            pertambahanBerat: weightHistoryFetchFromAPI[index].pertambahanBerat,
          ));
        }
      }
    }
  }

  Future<void> _syncMasterDataVersion(List<MasterDataVersion>? masterDataVersion) async {
    if (masterDataVersion != null) {
      MasterDataVersion? masterDataFoodVersion = masterDataVersion.firstWhereOrNull((masterData) => masterData.masterTable == "master_food");
      MasterDataVersion? masterDataKehamilanVersion = masterDataVersion.firstWhereOrNull((masterData) => masterData.masterTable == "master_kehamilan");
      MasterDataVersion? masterDataVaccineVersion = masterDataVersion.firstWhereOrNull((masterData) => masterData.masterTable == "master_vaccines");
      MasterDataVersion? masterDataVitaminVersion = masterDataVersion.firstWhereOrNull((masterData) => masterData.masterTable == "master_vitamins");

      int majorVersionFood = storageService.getMajorVersionMasterFoodData();
      int minorVersionFood = storageService.getMinorVersionMasterFoodData();
      int majorVersionKehamilan = storageService.getMajorVersionMasterKehamilanData();
      int minorVersionKehamilan = storageService.getMinorVersionMasterKehamilanData();
      int majorVersionVaccine = storageService.getMajorVersionMasterVaccineData();
      int minorVersionVaccine = storageService.getMinorVersionMasterVaccineData();
      int majorVersionVitamin = storageService.getMajorVersionMasterVitaminData();
      int minorVersionVitamin = storageService.getMinorVersionMasterVitaminData();

      if (masterDataFoodVersion != null && (masterDataFoodVersion.majorVersion > majorVersionFood || (masterDataFoodVersion.majorVersion == majorVersionFood && masterDataFoodVersion.minorVersion > minorVersionFood))) {
        List<MasterFood> masterDataFood = await masterFoodService.getAllFood(null);
        List<MasterFood> masterDataFoodFromAPI = await masterDataRepository.getMasterDataFood();

        masterDataFoodFromAPI.forEach((dataAPI) {
          var getFoodDataById = masterDataFood.firstWhereOrNull((localData) => localData.id == dataAPI.id);

          if (getFoodDataById != null) {
            if (dataAPI.updatedAt!.isAfter(getFoodDataById.updatedAt ?? DateTime.now())) {
              masterFoodService.editFood(dataAPI);
            }
          } else {
            masterFoodService.addFood(dataAPI);
          }
        });

        masterDataFood.forEach((localData) {
          var getFoodDataById = masterDataFoodFromAPI.firstWhereOrNull((dataAPI) => dataAPI.id == localData.id);

          if (getFoodDataById == null) {
            masterFoodService.deleteFood(localData.id ?? 0);
          }
        });

        storageService.setMajorVersionMasterFoodData(masterDataFoodVersion.majorVersion);
        storageService.setMinorVersionMasterFoodData(masterDataFoodVersion.minorVersion);
      }

      if (masterDataKehamilanVersion != null && (masterDataKehamilanVersion.majorVersion > majorVersionKehamilan || (masterDataKehamilanVersion.majorVersion == majorVersionKehamilan && masterDataKehamilanVersion.minorVersion > minorVersionKehamilan))) {
        List<MasterPregnancy> masterDataKehamilan = await masterKehamilanService.getAllPregnancyData();
        List<MasterPregnancy> masterDataKehamilanFromAPI = await masterDataRepository.getMasterDataKehamilan();

        masterDataKehamilanFromAPI.forEach((dataAPI) {
          var getKehamilanDataById = masterDataKehamilan.firstWhereOrNull((localData) => localData.id == dataAPI.id);

          if (getKehamilanDataById != null) {
            if (dataAPI.updatedAt!.isAfter(getKehamilanDataById.updatedAt ?? DateTime.now())) {
              masterKehamilanService.editPregnancyData(dataAPI);
            }
          } else {
            masterKehamilanService.addPregnancyData(dataAPI);
          }
        });

        masterDataKehamilan.forEach((localData) {
          var getKehamilanDataById = masterDataKehamilanFromAPI.firstWhereOrNull((dataAPI) => dataAPI.id == localData.id);

          if (getKehamilanDataById == null) {
            masterKehamilanService.deletePregnancyData(localData.id ?? 0);
          }
        });

        storageService.setMajorVersionMasterKehamilanData(masterDataKehamilanVersion.majorVersion);
        storageService.setMinorVersionMasterKehamilanData(masterDataKehamilanVersion.minorVersion);
      }

      if (masterDataVaccineVersion != null && (masterDataVaccineVersion.majorVersion > majorVersionVaccine || (masterDataVaccineVersion.majorVersion == majorVersionVaccine && masterDataVaccineVersion.minorVersion > minorVersionVaccine))) {
        List<MasterVaccine> masterDataVaccine = await masterVaccinesService.getAllVaccines();
        List<MasterVaccine> masterDataVaccineFromAPI = await masterDataRepository.getMasterDataVaccines();

        masterDataVaccineFromAPI.forEach((dataAPI) {
          var getVaccineDataById = masterDataVaccine.firstWhereOrNull((localData) => localData.id == dataAPI.id);

          if (getVaccineDataById != null) {
            if (dataAPI.updatedAt!.isAfter(getVaccineDataById.updatedAt ?? DateTime.now())) {
              masterVaccinesService.editVaccine(dataAPI);
            }
          } else {
            masterVaccinesService.addVaccine(dataAPI);
          }
        });

        masterDataVaccine.forEach((localData) {
          var getVaccineDataById = masterDataVaccineFromAPI.firstWhereOrNull((dataAPI) => dataAPI.id == localData.id);

          if (getVaccineDataById == null) {
            masterVaccinesService.deleteVaccine(localData.id ?? 0);
          }
        });

        storageService.setMajorVersionMasterVaccineData(masterDataVaccineVersion.majorVersion);
        storageService.setMinorVersionMasterVaccineData(masterDataVaccineVersion.minorVersion);
      }

      if (masterDataVitaminVersion != null && (masterDataVitaminVersion.majorVersion > majorVersionVitamin || (masterDataVitaminVersion.majorVersion == majorVersionVitamin && masterDataVitaminVersion.minorVersion > minorVersionVitamin))) {
        List<MasterVitamin> masterDataVitamin = await masterVitaminsService.getAllVitamin();
        List<MasterVitamin> masterDataVitaminFromAPI = await masterDataRepository.getMasterDataVitamin();

        masterDataVitaminFromAPI.forEach((dataAPI) {
          var getVitaminDataById = masterDataVitamin.firstWhereOrNull((localData) => localData.id == dataAPI.id);

          if (getVitaminDataById != null) {
            if (dataAPI.updatedAt!.isAfter(getVitaminDataById.updatedAt ?? DateTime.now())) {
              masterVitaminsService.editVitamin(dataAPI);
            }
          } else {
            masterVitaminsService.addVitamin(dataAPI);
          }
        });

        masterDataVitamin.forEach((localData) {
          var getVitaminDataById = masterDataVitaminFromAPI.firstWhereOrNull((dataAPI) => dataAPI.id == localData.id);

          if (getVitaminDataById == null) {
            masterVitaminsService.deleteVitamin(localData.id ?? 0);
          }
        });

        storageService.setMajorVersionMasterVitaminData(masterDataVitaminVersion.majorVersion);
        storageService.setMinorVersionMasterVitaminData(masterDataVitaminVersion.minorVersion);
      }
    }
  }

  Future<void> _syncPregnancyDailyLogData(List<PregnancyDailyLog>? pregnancyDailyLog, PregnancyDailyLog? fetchedPregnancyDailyLog, int userId) async {
    if (fetchedPregnancyDailyLog == null) {
      for (var localLog in pregnancyDailyLog ?? []) {
        await pregnancyLogRepository.deletePregnancyDailyLog(localLog.id!);
      }
      return;
    }

    List<DataHarianKehamilan>? fetchedDataHarianKehamilan = fetchedPregnancyDailyLog.dataHarianKehamilan;
    List<BloodPressure>? fetchedTekananDarah = fetchedPregnancyDailyLog.tekananDarah;
    List<ContractionTimer>? fetchedTimerKontraksi = fetchedPregnancyDailyLog.timerKontraksi;
    List<BabyKicks>? fetchedGerakanBayi = fetchedPregnancyDailyLog.gerakanBayi;

    PregnancyHistory? currentPregnancy = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
    if (currentPregnancy == null) return;

    if (pregnancyDailyLog != null && pregnancyDailyLog.isNotEmpty) {
      for (var localLog in pregnancyDailyLog) {
        if (localLog.riwayatKehamilanId != currentPregnancy.id) {
          await pregnancyLogRepository.deletePregnancyDailyLog(localLog.id!);
        }
      }

      List<PregnancyDailyLog>? newLocalPregnancyLogs = await pregnancyLogRepository.getAllPregnancyDailyLog(userId);
      PregnancyDailyLog? newLocalPregnancyLog = newLocalPregnancyLogs?.firstWhereOrNull((log) => log.riwayatKehamilanId == currentPregnancy.id);
      if (newLocalPregnancyLog == null) return;

      List<DataHarianKehamilan>? localDataHarianKehamilan = newLocalPregnancyLog.dataHarianKehamilan;
      List<BloodPressure>? localTekananDarah = newLocalPregnancyLog.tekananDarah;
      List<ContractionTimer>? localTimerKontraksi = newLocalPregnancyLog.timerKontraksi;
      List<BabyKicks>? localGerakanBayi = newLocalPregnancyLog.gerakanBayi;

      if (fetchedDataHarianKehamilan != null) {
        if (localDataHarianKehamilan != null) {
          for (var localDataHarian in localDataHarianKehamilan) {
            bool found = fetchedDataHarianKehamilan.any((data) => data.date == localDataHarian.date);
            if (!found) {
              await pregnancyLogService.deletePregnancyDailyLog(localDataHarian.date);
            }
          }

          for (var fetchedData in fetchedDataHarianKehamilan) {
            await pregnancyLogService.upsertPregnancyDailyLog(
              DateTime.parse(fetchedData.date),
              fetchedData.pregnancySymptoms?.toJson(),
              double.tryParse(fetchedData.temperature ?? ""),
              fetchedData.notes,
            );
          }
        } else {
          for (var fetchedData in fetchedDataHarianKehamilan) {
            await pregnancyLogService.upsertPregnancyDailyLog(
              DateTime.parse(fetchedData.date),
              fetchedData.pregnancySymptoms?.toJson(),
              double.tryParse(fetchedData.temperature ?? ""),
              fetchedData.notes,
            );
          }
        }
      } else {
        PregnancyDailyLog updateLocalLog = newLocalPregnancyLog.copyWith(dataHarianKehamilan: [], updatedAt: DateTime.now().toString());
        await pregnancyLogRepository.upsertPregnancyDailyLog(updateLocalLog);
      }

      if (fetchedTekananDarah != null) {
        if (localTekananDarah != null) {
          for (var localData in localTekananDarah) {
            bool found = fetchedTekananDarah.any((data) => data.id == localData.id && data.systolicPressure == localData.systolicPressure && data.diastolicPressure == localData.diastolicPressure && data.heartRate == localData.heartRate && data.datetime == localData.datetime);
            if (!found) {
              await pregnancyLogService.deleteBloodPressure(localData.id!);
            }
          }

          for (var fetchedData in fetchedTekananDarah) {
            await pregnancyLogService.addBloodPressure(fetchedData);
          }
        } else {
          for (var fetchedData in fetchedTekananDarah) {
            await pregnancyLogService.addBloodPressure(fetchedData);
          }
        }
      } else {
        PregnancyDailyLog updateLocalLog = newLocalPregnancyLog.copyWith(tekananDarah: [], updatedAt: DateTime.now().toString());
        await pregnancyLogRepository.upsertPregnancyDailyLog(updateLocalLog);
      }

      if (fetchedTimerKontraksi != null) {
        if (localTimerKontraksi != null) {
          for (var localData in localTimerKontraksi) {
            bool found = fetchedTimerKontraksi.any((data) => data.id == localData.id && data.timeStart == localData.timeStart && data.duration == localData.duration && data.interval == localData.interval);
            if (!found) {
              await pregnancyLogService.deleteContractionTimer(localData.id!);
            }
          }

          for (var fetchedData in fetchedTimerKontraksi) {
            await pregnancyLogService.addContractionTimer(fetchedData.id!, fetchedData.timeStart, fetchedData.duration);
          }
        } else {
          for (var fetchedData in fetchedTimerKontraksi) {
            await pregnancyLogService.addContractionTimer(fetchedData.id!, fetchedData.timeStart, fetchedData.duration);
          }
        }
      } else {
        PregnancyDailyLog updateLocalLog = newLocalPregnancyLog.copyWith(timerKontraksi: [], updatedAt: DateTime.now().toString());
        await pregnancyLogRepository.upsertPregnancyDailyLog(updateLocalLog);
      }

      if (fetchedGerakanBayi != null) {
        if (localGerakanBayi != null) {
          for (var localData in localGerakanBayi) {
            bool found = fetchedGerakanBayi.any((data) => data.id == localData.id && data.datetimeStart == localData.datetimeStart && data.datetimeEnd == localData.datetimeEnd && data.totalKicks == localData.totalKicks);
            if (!found) {
              await pregnancyLogService.deleteKicksCounter(localData.id!);
            }
          }

          for (var fetchedData in fetchedGerakanBayi) {
            await pregnancyLogService.addKickData(fetchedData);
          }
        } else {
          for (var fetchedData in fetchedGerakanBayi) {
            await pregnancyLogService.addKickData(fetchedData);
          }
        }
      } else {
        PregnancyDailyLog updateLocalLog = newLocalPregnancyLog.copyWith(timerKontraksi: [], updatedAt: DateTime.now().toString());
        await pregnancyLogRepository.upsertPregnancyDailyLog(updateLocalLog);
      }
    } else {
      if (fetchedDataHarianKehamilan != null) {
        for (var fetchedData in fetchedDataHarianKehamilan) {
          await pregnancyLogService.upsertPregnancyDailyLog(
            DateTime.parse(fetchedData.date),
            fetchedData.pregnancySymptoms?.toJson() ?? {},
            double.tryParse(fetchedData.temperature ?? ""),
            fetchedData.notes,
          );
        }
      }

      if (fetchedTekananDarah != null) {
        for (var fetchedData in fetchedTekananDarah) {
          await pregnancyLogService.addBloodPressure(fetchedData);
        }
      }

      if (fetchedTimerKontraksi != null) {
        for (var fetchedData in fetchedTimerKontraksi) {
          await pregnancyLogService.addContractionTimer(fetchedData.id!, fetchedData.timeStart, fetchedData.duration);
        }
      }

      if (fetchedGerakanBayi != null) {
        for (var fetchedData in fetchedGerakanBayi) {
          await pregnancyLogService.addKickData(fetchedData);
        }
      }
    }
  }

  Future<void> pendingDataChange() async {
    try {
      int userId = storageService.getAccountLocalId();
      List<SyncLog> getAllSyncLogData = await _syncDataRepository.getAllSyncLogData();
      print("Pending Data: ${getAllSyncLogData.length}");

      // for (var synclog in getAllSyncLogData) {
      //   _syncDataRepository.deleteSyncLogData(synclog.id ?? 0);
      // }

      if (getAllSyncLogData.isNotEmpty) {
        for (var syncLog in getAllSyncLogData) {
          if (syncLog.data != null) {
            Map<String, dynamic> data;
            try {
              data = jsonDecode(syncLog.data!);
            } catch (e) {
              _logger.e("Error decoding JSON data: $e");
              continue;
            }

            bool success = false;

            try {
              switch (syncLog.tableName) {
                case "tb_user":
                  if (syncLog.operation == "updateProfile") {
                    await profileRepository.editProfile(data['nama'], data['tanggalLahir']);
                    success = true;
                  }
                  break;

                case "tb_data_harian":
                  if (syncLog.operation == "upsertDailyLog") {
                    await logRepository.storeLog(
                      data['date'],
                      data['sexActivity'],
                      data['bleedingFlow'],
                      data['symptoms'],
                      data['vaginalDischarge'],
                      data['moods'],
                      data['others'],
                      data['physicalActivity'],
                      data['temperature'],
                      data['weight'],
                      data['notes'],
                    );
                    success = true;
                  } else if (syncLog.operation == "addReminder") {
                    await logRepository.storeReminder(
                      data['id'],
                      data['title'],
                      data['description'],
                      data['datetime'],
                    );
                    success = true;
                  } else if (syncLog.operation == "editReminder") {
                    await logRepository.editReminder(
                      data['id'],
                      data['title'],
                      data['description'],
                      data['datetime'],
                    );
                    success = true;
                  } else if (syncLog.operation == "deleteReminder") {
                    await logRepository.deleteReminder(
                      data['id'],
                    );
                    success = true;
                  }
                  break;

                case "tb_riwayat_mens":
                  if (syncLog.operation == "addPeriod") {
                    if (data['periods'] is List) {
                      List<Map<String, dynamic>> periods = List<Map<String, dynamic>>.from(data['periods']);
                      List<PeriodHistory>? periodAdded = await periodRepository.storePeriod(
                        periods,
                        data['periodCycle'],
                        null,
                      );

                      if (periodAdded != null) {
                        for (var newPeriodAdd in periodAdded) {
                          List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
                          PeriodHistory? localPeriodAdded = getAllPeriodHistory.firstWhereOrNull(
                            (period) => formatDate(period.haidAwal!) == formatDate(newPeriodAdd.haidAwal!) && formatDate(period.haidAkhir!) == formatDate(newPeriodAdd.haidAkhir!),
                          );

                          if (localPeriodAdded != null) {
                            PeriodHistory editPeriodId = localPeriodAdded.copyWith(remoteId: newPeriodAdd.id);
                            await _periodHistoryRepository.editPeriodHistory(editPeriodId);
                          }
                        }
                      }

                      success = true;
                    } else {
                      _logger.e("Error: periods data is not a list of maps");
                    }
                  } else if (syncLog.operation == "updatePeriod") {
                    await periodRepository.updatePeriod(
                      data['periodId'],
                      data['firstPeriod'],
                      data['lastPeriod'],
                      data['periodCycle'],
                    );
                    success = true;
                  }
                  break;

                case "tb_riwayat_kehamilan":
                  if (syncLog.operation == "beginPregnancy") {
                    var addedPregnancy = await pregnancyRepository.pregnancyBegin(
                      data['firstDayLastMenstruation'],
                      null,
                    );
                    List<PregnancyHistory> getAllPregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
                    PregnancyHistory? pregnancyHistoryAdded = getAllPregnancyHistory.firstWhereOrNull((pregnancy) => formatDate(DateTime.parse(pregnancy.hariPertamaHaidTerakhir!)) == formatDate(DateTime.parse(data['firstDayLastMenstruation'])));

                    if (pregnancyHistoryAdded != null) {
                      PregnancyHistory editPregnancyId = pregnancyHistoryAdded.copyWith(remoteId: addedPregnancy["data"]["user_id"]);
                      await _pregnancyHistoryRepository.editPregnancy(editPregnancyId);
                    }

                    success = true;
                  } else if (syncLog.operation == "endPregnancy") {
                    await pregnancyRepository.pregnancyEnded(
                      data['pregnancyEndDate'],
                      data['gender'],
                    );
                    success = true;
                  } else if (syncLog.operation == "deletePregnancy") {
                    await pregnancyRepository.deletePregnancy();
                    success = true;
                  }
                  break;

                case "tb_berat_badan_kehamilan":
                  if (syncLog.operation == "initWeightGain") {
                    await pregnancyRepository.initializeWeightGain(
                      data['tinggiBadan'],
                      data['beratBadan'],
                      data['isTwin'],
                    );
                    success = true;
                  } else if (syncLog.operation == "addWeeklyWeightGain") {
                    await pregnancyRepository.weeklyWeightGain(
                      data['beratBadan'],
                      data['mingguKehamilan'],
                      data['dateRecord'],
                    );
                    success = true;
                  } else if (syncLog.operation == "deleteWeeklyWeightGain") {
                    await pregnancyRepository.deleteWeeklyWeightGain(data['tanggalPencatatan']);
                    success = true;
                  }
                  break;

                case "tb_data_harian_kehamilan":
                  if (syncLog.operation == "upsertPregnancyDailyLog") {
                    await pregnancyLogAPIRepository.storePregnancyLog(
                      DateTime.parse(data['date']),
                      data['pregnancySymptoms'],
                      double.tryParse(data['temperature']),
                      data['notes'],
                    );
                    success = true;
                  }

                  if (syncLog.operation == "deletePregnancyDailyLog") {
                    await pregnancyLogAPIRepository.deletePregnancyLog(
                      DateTime.parse(data['date']),
                    );
                    success = true;
                  }

                  if (syncLog.operation == "addContractionTimer") {
                    await pregnancyLogAPIRepository.addContractionTimer(
                      data['id'],
                      DateTime.parse(data['startDate']),
                      data['duration'],
                    );
                    success = true;
                  }

                  if (syncLog.operation == "deleteContractionTimer") {
                    await pregnancyLogAPIRepository.deleteContractionTimer(
                      data['id'],
                    );
                    success = true;
                  }

                  if (syncLog.operation == "addBloodPressure") {
                    await pregnancyLogAPIRepository.addBloodPressure(
                      data['id'],
                      data['tekananSistolik'],
                      data['tekananDiastolik'],
                      data['detakJantung'],
                      DateTime.parse(data['datetime']),
                    );
                    success = true;
                  }

                  if (syncLog.operation == "editBloodPressure") {
                    await pregnancyLogAPIRepository.editBloodPressure(
                      data['id'],
                      data['tekananSistolik'],
                      data['tekananDiastolik'],
                      data['detakJantung'],
                      DateTime.parse(data['datetime']),
                    );
                    success = true;
                  }

                  if (syncLog.operation == "deleteBloodPressure") {
                    await pregnancyLogAPIRepository.deleteBloodPressure(
                      data['id'],
                    );
                    success = true;
                  }

                  if (syncLog.operation == "addKickCounter") {
                    await pregnancyLogAPIRepository.addKickCounter(
                      data['id'],
                      DateTime.parse(data['datetime']),
                    );
                    success = true;
                  }

                  if (syncLog.operation == "deleteKickCounter") {
                    await pregnancyLogAPIRepository.deleteKickCounter(
                      data['id'],
                    );
                    success = true;
                  }

                default:
                  _logger.e("Error during sync data: table not found");
                  break;
              }

              if (success) {
                await _syncDataRepository.deleteSyncLogData(syncLog.id!);
              }
            } catch (e) {
              _logger.e("Error during sync operation for ${syncLog.tableName}: $e");
              continue;
            }
          }
        }
      } else {
        _logger.i("No pending data change");
      }
    } catch (e) {
      _logger.e("Error during sync data: $e");
      throw Exception('Data tidak lengkap');
    }
  }

  Future<void> rebackupData() async {
    try {
      int userId = storageService.getAccountLocalId();
      User? profile = await _localProfileRepository.getProfile();
      DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);
      List<PregnancyDailyLog>? pregnancyDailyLog = await pregnancyLogRepository.getAllPregnancyDailyLog(userId);
      List<PeriodHistory>? periodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PeriodHistory>? isActualPeriodHistory = periodHistory.where((period) => period.isActual == "1").toList();
      List<PregnancyHistory>? pregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
      List<WeightHistory>? weightHistory = await _weightHistoryRepository.getWeightHistory(userId);

      if (profile != null) {
        await profileRepository.editProfile(profile.nama!, profile.tanggalLahir!);
      }

      if (dailyLog != null) {
        List<DataHarian>? localDataHarian = dailyLog.dataHarian;
        List<Reminders>? localReminders = dailyLog.pengingat;

        if (localDataHarian!.length > 0) {
          for (var dataHarian in localDataHarian) {
            await logRepository.storeLog(
              dataHarian.date!,
              dataHarian.sexActivity ?? "",
              dataHarian.bleedingFlow ?? "",
              dataHarian.symptoms?.toJson() ?? {},
              dataHarian.vaginalDischarge ?? "",
              dataHarian.moods?.toJson() ?? {},
              dataHarian.others?.toJson() ?? {},
              dataHarian.physicalActivity?.toJson() ?? {},
              dataHarian.temperature ?? "",
              dataHarian.weight ?? "",
              dataHarian.notes ?? "",
            );
          }
        }

        if (localReminders!.length > 0) {
          for (var reminder in localReminders) {
            await logRepository.storeReminder(
              reminder.id!,
              reminder.title!,
              reminder.description!,
              reminder.datetime!,
            );
          }
        }
      }

      if (isActualPeriodHistory.length > 0) {
        for (var period in isActualPeriodHistory) {
          var periodAdded = await periodRepository.storePeriod([
            {
              "first_period": formatDate(period.haidAwal!),
              "last_period": formatDate(period.haidAkhir!),
            }
          ], period.lamaSiklus, null);

          if (periodAdded != null) {
            for (var newPeriodAdd in periodAdded) {
              PeriodHistory editPeriodId = period.copyWith(remoteId: newPeriodAdd.id);
              await _periodHistoryRepository.editPeriodHistory(editPeriodId);
            }
          }
        }
      }

      if (pregnancyHistory.length > 0) {
        for (var pregnancy in pregnancyHistory) {
          if (pregnancy.kehamilanAkhir != null) {
            var pregnancyBegin = await pregnancyRepository.pregnancyBegin(pregnancy.hariPertamaHaidTerakhir!, null);
            if (pregnancyBegin.isNotEmpty) {
              PregnancyHistory editPregnancyId = pregnancy.copyWith(remoteId: pregnancyBegin["data"]["user_id"]);
              await _pregnancyHistoryRepository.editPregnancy(editPregnancyId);
            }
            await pregnancyRepository.pregnancyEnded(pregnancy.kehamilanAkhir!, pregnancy.gender!);
          } else {
            var pregnancyBegin = await pregnancyRepository.pregnancyBegin(pregnancy.hariPertamaHaidTerakhir!, null);
            if (pregnancyBegin.isNotEmpty) {
              PregnancyHistory editPregnancyId = pregnancy.copyWith(remoteId: pregnancyBegin["data"]["user_id"]);
              await _pregnancyHistoryRepository.editPregnancy(editPregnancyId);
            }
          }

          if (weightHistory.length > 0) {
            for (var weight in weightHistory) {
              if (weight.riwayatKehamilanId == pregnancy.id) {
                if (weight.mingguKehamilan == 0) {
                  await pregnancyRepository.initializeWeightGain(pregnancy.tinggiBadan!, weight.beratBadan!, int.parse(pregnancy.isTwin!));
                } else {
                  await pregnancyRepository.weeklyWeightGain(weight.beratBadan!, weight.mingguKehamilan!, weight.tanggalPencatatan!);
                }
              }
            }
          }
        }
      }

      if (pregnancyDailyLog != null) {
        for (var pregnancyLog in pregnancyDailyLog) {
          List<DataHarianKehamilan>? localDataHarianKehamilan = pregnancyLog.dataHarianKehamilan;
          List<BloodPressure>? localTekananDarah = pregnancyLog.tekananDarah;
          List<ContractionTimer>? localTimerKontraksi = pregnancyLog.timerKontraksi;
          List<BabyKicks>? localGerakanBayi = pregnancyLog.gerakanBayi;

          if (localDataHarianKehamilan != null) {
            for (var dataHarianKehamilan in localDataHarianKehamilan) {
              print(dataHarianKehamilan.pregnancySymptoms?.toJson());
              await pregnancyLogAPIRepository.storePregnancyLog(
                DateTime.parse(dataHarianKehamilan.date),
                dataHarianKehamilan.pregnancySymptoms?.toJson() ?? {},
                double.tryParse(dataHarianKehamilan.temperature ?? ""),
                dataHarianKehamilan.notes ?? "",
              );
            }
          }

          if (localTekananDarah != null) {
            for (var tekananDarah in localTekananDarah) {
              await pregnancyLogAPIRepository.addBloodPressure(
                tekananDarah.id!,
                tekananDarah.systolicPressure,
                tekananDarah.diastolicPressure,
                tekananDarah.heartRate,
                DateTime.parse(tekananDarah.datetime),
              );
            }
          }

          if (localTimerKontraksi != null) {
            for (var timerKontraksi in localTimerKontraksi) {
              await pregnancyLogAPIRepository.addContractionTimer(
                timerKontraksi.id!,
                DateTime.parse(timerKontraksi.timeStart),
                timerKontraksi.duration,
              );
            }
          }

          if (localGerakanBayi != null) {
            for (var gerakanBayi in localGerakanBayi) {
              await pregnancyLogAPIRepository.addKickCounterData(
                gerakanBayi.id!,
                DateTime.parse(gerakanBayi.datetimeStart),
                DateTime.parse(gerakanBayi.datetimeEnd),
                gerakanBayi.totalKicks,
              );
            }
          }
        }
      }
    } catch (e) {
      _logger.e("Error during rebackup data: $e");
      throw Exception('Data tidak lengkap');
    }
  }
}
