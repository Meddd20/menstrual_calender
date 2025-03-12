import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

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

  late final PeriodHistoryRepository _periodHistoryRepository = PeriodHistoryRepository();
  late final PregnancyHistoryRepository _pregnancyHistoryRepository = PregnancyHistoryRepository();
  late final WeightHistoryRepository _weightHistoryRepository = WeightHistoryRepository();
  late final LocalProfileRepository _localProfileRepository = LocalProfileRepository();
  late final SyncDataRepository _syncDataRepository = SyncDataRepository();
  late final LocalLogRepository _localLogRepository = LocalLogRepository();
  late final PregnancyLogRepository pregnancyLogRepository = PregnancyLogRepository();

  late final PeriodHistoryService periodHistoryService = PeriodHistoryService();
  late final PregnancyHistoryService pregnancyHistoryService = PregnancyHistoryService();
  late final WeightHistoryService weightHistoryService = WeightHistoryService();
  late final LogService logService = LogService();
  late final MasterFoodService masterFoodService = MasterFoodService();
  late final MasterKehamilanService masterKehamilanService = MasterKehamilanService();
  late final MasterVaccinesService masterVaccinesService = MasterVaccinesService();
  late final MasterVitaminsService masterVitaminsService = MasterVitaminsService();
  late final PregnancyLogService pregnancyLogService = PregnancyLogService();

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
      List<PregnancyHistory>? pregnancyHistoryFetchFromAPI = dataFetchFromAPI?.pregnancyHistory;
      List<WeightHistory>? weightHistoryFetchFromAPI = dataFetchFromAPI?.weightGainHistory;
      PregnancyDailyLog? pregnancyDailyLogFetchFromAPI = dataFetchFromAPI?.pregnancyDailyLog;

      await _syncSafe(() => _syncUserData(profile, profileFetchFromAPI, userId));
      await _syncSafe(() => _syncDailyLogData(dailyLog, dailyLogFetchFromAPI, userId));
      await _syncSafe(() => _syncPeriodHistoryData(periodHistory, periodHistoryFetchFromAPI, userId));
      await _syncSafe(() => _syncPregnancyHistoryData(pregnancyHistory, pregnancyHistoryFetchFromAPI, userId));
      await _syncSafe(() => _syncPregnancyDailyLogData(pregnancyDailyLog, pregnancyDailyLogFetchFromAPI, userId));
      await _syncSafe(() => _syncWeightHistoryData(weightHistory, weightHistoryFetchFromAPI, userId));
    } catch (e) {
      _logger.e("Unexpected error during sync data: $e");
      throw Exception('Unexpected error during sync data');
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
        for (var periodHistory in isActualPeriodHistoryFromAPI) {
          if (periodHistory.id != null && periodHistory.haidAwal != null && periodHistory.haidAkhir != null) {
            await periodHistoryService.addPeriod(
              periodHistory.id,
              periodHistory.haidAwal!,
              periodHistory.haidAkhir!,
              periodHistory.lamaSiklus,
            );
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

  Future<void> _syncPregnancyHistoryData(List<PregnancyHistory>? pregnancyHistory, List<PregnancyHistory>? pregnancyHistoryFetchFromAPI, int userId) async {
    if (pregnancyHistoryFetchFromAPI != null) {
      if (pregnancyHistory == null || pregnancyHistory.isEmpty) {
        for (var pregnancyHistory in pregnancyHistoryFetchFromAPI) {
          await _syncDataRepository.fetchNewlySyncPregnancyHistoryData(pregnancyHistory, userId);
        }
      } else {
        List<int> notFoundInLocal = [];

        for (var i = 0; i < pregnancyHistoryFetchFromAPI.length; i++) {
          bool foundMatch = false;

          for (var j = 0; j < pregnancyHistory.length; j++) {
            if (pregnancyHistory[j].status == pregnancyHistoryFetchFromAPI[i].status &&
                pregnancyHistory[j].hariPertamaHaidTerakhir == pregnancyHistoryFetchFromAPI[i].hariPertamaHaidTerakhir &&
                pregnancyHistory[j].kehamilanAkhir == pregnancyHistoryFetchFromAPI[i].kehamilanAkhir &&
                pregnancyHistory[j].tinggiBadan == pregnancyHistoryFetchFromAPI[i].tinggiBadan &&
                pregnancyHistory[j].beratPrakehamilan == pregnancyHistoryFetchFromAPI[i].beratPrakehamilan &&
                pregnancyHistory[j].gender == pregnancyHistoryFetchFromAPI[i].gender &&
                pregnancyHistory[j].isTwin == pregnancyHistoryFetchFromAPI[i].isTwin) {
              foundMatch = true;
              break;
            }
          }

          if (!foundMatch) {
            notFoundInLocal.add(i);
          }
        }

        for (var j = 0; j < pregnancyHistory.length; j++) {
          bool foundInApi = false;

          for (var i = 0; i < pregnancyHistoryFetchFromAPI.length; i++) {
            if (pregnancyHistory[j].status == pregnancyHistoryFetchFromAPI[i].status &&
                pregnancyHistory[j].hariPertamaHaidTerakhir == pregnancyHistoryFetchFromAPI[i].hariPertamaHaidTerakhir &&
                pregnancyHistory[j].kehamilanAkhir == pregnancyHistoryFetchFromAPI[i].kehamilanAkhir &&
                pregnancyHistory[j].tinggiBadan == pregnancyHistoryFetchFromAPI[i].tinggiBadan &&
                pregnancyHistory[j].beratPrakehamilan == pregnancyHistoryFetchFromAPI[i].beratPrakehamilan &&
                pregnancyHistory[j].gender == pregnancyHistoryFetchFromAPI[i].gender &&
                pregnancyHistory[j].isTwin == pregnancyHistoryFetchFromAPI[i].isTwin) {
              foundInApi = true;
              break;
            }
          }

          if (!foundInApi) {
            await _pregnancyHistoryRepository.deletePregnancy(pregnancyHistory[j].id!);
          }
        }

        for (var index in notFoundInLocal) {
          await _pregnancyHistoryRepository.addPregnancyData(
            pregnancyHistoryFetchFromAPI[index],
            userId,
            remoteId: pregnancyHistoryFetchFromAPI[index].id,
          );
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
              fetchedData.fundusUteriHeight ?? null,
              fetchedData.fetalHeartRate ?? null,
              fetchedData.examinationMethod ?? null,
              fetchedData.fetalPosition ?? null,
              fetchedData.placentaCondition ?? null,
              fetchedData.fetalWeight ?? null,
            );
          }
        } else {
          for (var fetchedData in fetchedDataHarianKehamilan) {
            await pregnancyLogService.upsertPregnancyDailyLog(
              DateTime.parse(fetchedData.date),
              fetchedData.pregnancySymptoms?.toJson(),
              double.tryParse(fetchedData.temperature ?? ""),
              fetchedData.notes,
              fetchedData.fundusUteriHeight ?? null,
              fetchedData.fetalHeartRate ?? null,
              fetchedData.examinationMethod ?? null,
              fetchedData.fetalPosition ?? null,
              fetchedData.placentaCondition ?? null,
              fetchedData.fetalWeight ?? null,
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
            fetchedData.fundusUteriHeight ?? null,
            fetchedData.fetalHeartRate ?? null,
            fetchedData.examinationMethod ?? null,
            fetchedData.fetalPosition ?? null,
            fetchedData.placentaCondition ?? null,
            fetchedData.fetalWeight ?? null,
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

  Future<void> syncMasterDataVersion() async {
    List<MasterDataVersion>? masterDataVersion = await profileRepository.fetchSyncMasterDataVersion();

    if (masterDataVersion != null && masterDataVersion.isNotEmpty) {
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
        List<MasterFood> masterDataFoodFromAPI = await masterDataRepository.getMasterDataFood();

        masterFoodService.addAllFood(masterDataFoodFromAPI);

        storageService.setMajorVersionMasterFoodData(masterDataFoodVersion.majorVersion);
        storageService.setMinorVersionMasterFoodData(masterDataFoodVersion.minorVersion);
      }

      if (masterDataKehamilanVersion != null && (masterDataKehamilanVersion.majorVersion > majorVersionKehamilan || (masterDataKehamilanVersion.majorVersion == majorVersionKehamilan && masterDataKehamilanVersion.minorVersion > minorVersionKehamilan))) {
        List<MasterPregnancy> masterDataKehamilan = await masterKehamilanService.getAllPregnancyData();
        List<MasterPregnancy> masterDataKehamilanFromAPI = await masterDataRepository.getMasterDataKehamilan();

        for (var dataAPI in masterDataKehamilanFromAPI) {
          MasterPregnancy? getKehamilanDataById = masterDataKehamilan.firstWhereOrNull((localData) => localData.id == dataAPI.id);
          DateTime dataAPIUpdatedAt = formatDateWithoutZ(dataAPI.updatedAt ?? DateTime.now().toUtc());

          if (getKehamilanDataById != null) {
            if (dataAPIUpdatedAt.isAfter(getKehamilanDataById.updatedAt ?? DateTime.now().toUtc())) {
              await masterKehamilanService.editPregnancyData(dataAPI);
            }
          } else {
            await masterKehamilanService.addPregnancyData(dataAPI);
          }
        }

        for (var localData in masterDataKehamilan) {
          MasterPregnancy? getKehamilanDataById = masterDataKehamilanFromAPI.firstWhereOrNull((dataAPI) => dataAPI.id == localData.id);
          if (getKehamilanDataById == null) {
            await masterKehamilanService.deletePregnancyData(localData.id ?? 0);
          }
        }

        storageService.setMajorVersionMasterKehamilanData(masterDataKehamilanVersion.majorVersion);
        storageService.setMinorVersionMasterKehamilanData(masterDataKehamilanVersion.minorVersion);
      }

      if (masterDataVaccineVersion != null && (masterDataVaccineVersion.majorVersion > majorVersionVaccine || (masterDataVaccineVersion.majorVersion == majorVersionVaccine && masterDataVaccineVersion.minorVersion > minorVersionVaccine))) {
        List<MasterVaccine> masterDataVaccineFromAPI = await masterDataRepository.getMasterDataVaccines();

        masterVaccinesService.addAllVaccines(masterDataVaccineFromAPI);

        storageService.setMajorVersionMasterVaccineData(masterDataVaccineVersion.majorVersion);
        storageService.setMinorVersionMasterVaccineData(masterDataVaccineVersion.minorVersion);
      }

      if (masterDataVitaminVersion != null && (masterDataVitaminVersion.majorVersion > majorVersionVitamin || (masterDataVitaminVersion.majorVersion == majorVersionVitamin && masterDataVitaminVersion.minorVersion > minorVersionVitamin))) {
        List<MasterVitamin> masterDataVitaminFromAPI = await masterDataRepository.getMasterDataVitamin();

        masterVitaminsService.addAllVitamins(masterDataVitaminFromAPI);

        storageService.setMajorVersionMasterVitaminData(masterDataVitaminVersion.majorVersion);
        storageService.setMinorVersionMasterVitaminData(masterDataVitaminVersion.minorVersion);
      }
    }
  }

  Map<K, List<T>> groupBy<T, K>(List<T> items, K Function(T) keyFunc) {
    var map = <K, List<T>>{};
    for (var item in items) {
      var key = keyFunc(item);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(item);
    }
    return map;
  }

  Future<void> pendingDataChange() async {
    try {
      int userId = storageService.getAccountLocalId();
      User? profile = await _localProfileRepository.getProfile();
      DailyLog? logs = await _localLogRepository.getDailyLog(userId);
      List<DataHarian>? dailyLogs = logs?.dataHarian;
      List<Reminders>? reminders = logs?.pengingat;
      List<PeriodHistory>? periodHistories = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PregnancyHistory>? pregnancyHistories = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
      List<WeightHistory>? weightHistories = await _weightHistoryRepository.getWeightHistory(userId);
      List<PregnancyDailyLog>? pregnancyDailyLogs = await pregnancyLogRepository.getAllPregnancyDailyLog(userId);

      List<SyncLog> syncLogs = await _syncDataRepository.getAllSyncLogData();
      var groupedByTable = groupBy(syncLogs, (log) => log.tableName);
      Map<String, dynamic> syncData = {'data': {}};
      print("Pending Data: ${syncLogs.length}");

      if (syncLogs.isNotEmpty) {
        for (var table in groupedByTable.keys) {
          var logs = groupedByTable[table];
          syncData['data'][table] = {'create': [], 'update': [], 'delete': []};

          Map<String, List<String>> operationListMap = {};

          if (logs != null) {
            for (var log in logs) {
              String? dataId = log.dataId.toString();
              String? optionalId = log.optionalId.toString();
              String operation = log.operation;

              String key = getUniqueKey(table, dataId, optionalId);

              if (key.isNotEmpty) {
                if (!operationListMap.containsKey(key)) {
                  operationListMap[key] = [];
                }

                operationListMap[key]?.add(operation);
              }
            }
          }

          if (table == 'user') {
            syncData['data']['user'] ??= {};
            syncData['data']['user']['update'] ??= [];

            var alreadyInUpdate = syncData['data']['user']['update'].any((userData) => userData.id == profile?.id);

            if (alreadyInUpdate) {
              syncData['data']['user']['update'][0] = profile?.toJson();
            } else {
              syncData['data'][table]['update'].add(profile?.toJson());
            }
          } else if (table == 'period') {
            for (var uniqueKey in operationListMap.keys) {
              var operations = operationListMap[uniqueKey]!;
              PeriodHistory? periodHistory = periodHistories.firstWhereOrNull((period) => period.id == int.tryParse(uniqueKey));
              var periodData = periodHistory?.toJson();

              String finalOperation = '';
              bool hasCreate = false;

              for (var operation in operations) {
                if (operation == 'create') {
                  hasCreate = true;
                  finalOperation = 'create';
                } else if (operation == 'update') {
                  if (!hasCreate) {
                    finalOperation = 'update';
                  }
                }
              }

              if (finalOperation == 'create') {
                if (periodHistory != null) {
                  syncData['data'][table]['create'].add(periodData);
                }
              } else {
                if (periodHistory != null) {
                  syncData['data'][table]['update'].add(periodData);
                }
              }
            }
          } else if (table == 'daily_log') {
            for (var uniqueKey in operationListMap.keys) {
              DataHarian? logByDate = dailyLogs?.firstWhereOrNull(
                (log) => log.date != null && DateTime.parse(log.date!).isAtSameMomentAs(DateTime.parse(uniqueKey)),
              );
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                finalOperation = operation;
              }

              if (finalOperation == 'create') {
                if (logByDate != null) {
                  syncData['data'][table]['create'].add(logByDate.toJson());
                }
              } else if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'date': uniqueKey});
              }
            }
          } else if (table == 'reminder') {
            for (var uniqueKey in operationListMap.keys) {
              var operations = operationListMap[uniqueKey]!;
              Reminders? reminder = reminders?.firstWhereOrNull((reminder) => reminder.id == uniqueKey);
              var reminderData = reminder?.toJson();

              String finalOperation = '';

              bool hasCreate = false;
              bool hasDelete = false;
              bool hasUpdate = false;

              for (var operation in operations) {
                if (operation == 'create') {
                  hasCreate = true;
                  finalOperation = 'create';
                } else if (operation == 'update') {
                  hasUpdate = true;
                  if (!hasCreate) {
                    finalOperation = 'update';
                  }
                } else if (operation == 'delete') {
                  hasDelete = true;
                  if (hasCreate) {
                    finalOperation = '';
                    break;
                  } else {
                    finalOperation = 'delete';
                  }
                }
              }

              if (hasCreate && hasUpdate && !hasDelete) {
                finalOperation = 'create';
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'id': uniqueKey});
              } else if (finalOperation == 'create') {
                if (reminderData != null) {
                  syncData['data'][table]['create'].add(reminderData);
                }
              } else if (finalOperation == 'update') {
                if (reminderData != null) {
                  syncData['data'][table]['update'].add(reminderData);
                }
              }
            }
          } else if (table == 'pregnancy') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'pregnancy' && syncLog.dataId == int.parse(uniqueKey));
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              User? profile = await _localProfileRepository.getProfile();

              var operations = operationListMap[uniqueKey]!;
              var pregnancyData = pregnancy?.toJson();
              pregnancyData?['is_pregnant'] = profile?.isPregnant;

              String finalOperation = '';

              bool hasCreate = false;
              bool hasDelete = false;
              bool hasUpdate = false;

              for (var operation in operations) {
                if (operation == 'create') {
                  hasCreate = true;
                  finalOperation = 'create';
                } else if (operation == 'update') {
                  hasUpdate = true;
                  if (!hasCreate) {
                    finalOperation = 'update';
                  }
                } else if (operation == 'delete') {
                  hasDelete = true;
                  if (hasCreate) {
                    finalOperation = '';
                    break;
                  } else {
                    finalOperation = 'delete';
                  }
                }
              }

              if (hasCreate && hasUpdate && !hasDelete) {
                finalOperation = 'create';
              }

              if (finalOperation == 'delete') {
                if (pregnancyData != null) {
                  syncData['data'][table]['delete'].add({'pregnancy_id': uniqueKey});
                }
              } else if (finalOperation == 'create') {
                if (pregnancyData != null) {
                  syncData['data'][table]['create'].add(pregnancyData);
                }
              } else if (finalOperation == 'update') {
                if (pregnancyData != null) {
                  syncData['data'][table]['update'].add(pregnancyData);
                }
              }
            }
          } else if (table == 'weight_gain') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog;

              if (uniqueKey != null) {
                dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'weight_gain' && syncLog.dataId != null && syncLog.optionalId == null);
              } else {
                dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'weight_gain' && DateTime.parse(syncLog.optionalId ?? "") == DateTime.parse(uniqueKey));
              }
              PregnancyHistory? weightPregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);

              WeightHistory? weightHistory = weightHistories.firstWhereOrNull((weight) => weight.tanggalPencatatan == uniqueKey);
              var weightHistoryData = weightHistory?.toJson();
              weightHistoryData?['first_date_last_period'] = weightPregnancy?.hariPertamaHaidTerakhir;

              if (weightHistory == null) {
                continue;
              }
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                finalOperation = operation;
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'tanggal_pencatatan': uniqueKey});
              } else if (finalOperation == 'create' || finalOperation == 'init') {
                syncData['data'][table]['create'].add(weightHistoryData);

                var pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == weightHistory.riwayatKehamilanId);

                syncData['data']['pregnancy'] ??= {};
                syncData['data']['pregnancy']['update'] ??= [];
                syncData['data']['pregnancy']['create'] ??= [];

                if (pregnancy != null) {
                  var pregnancyMap = pregnancy.toJson();
                  bool alreadyInUpdateOrCreate = syncData['data']['pregnancy']['update'].any((existingPregnancy) => existingPregnancy['id'] == pregnancyMap['id']) || syncData['data']['pregnancy']['create'].any((existingPregnancy) => existingPregnancy['id'] == pregnancyMap['id']);

                  if (!alreadyInUpdateOrCreate) {
                    syncData['data']['pregnancy']['update'].add(pregnancyMap);
                  }
                }
              }
            }
          } else if (table == 'pregnancy_log') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'pregnancy_log' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              PregnancyDailyLog? pregnancyLogs = pregnancyDailyLogs?.firstWhereOrNull((pregnancyDailyLog) => pregnancyDailyLog.riwayatKehamilanId == pregnancy?.id);
              List<DataHarianKehamilan>? pregnancyLog = pregnancyLogs?.dataHarianKehamilan;

              if (pregnancy == null || pregnancyLogs == null) {
                continue;
              }

              var operations = operationListMap[uniqueKey]!;
              DataHarianKehamilan? logByDate = pregnancyLog!.firstWhereOrNull(
                (log) => DateTime.parse(log.date).isAtSameMomentAs(formatDateStr(uniqueKey)),
              );
              var logByDateData = logByDate?.toJson();
              logByDateData?['first_date_last_period'] = pregnancy.hariPertamaHaidTerakhir;

              String finalOperation = '';

              for (var operation in operations) {
                finalOperation = operation;
              }

              if (finalOperation == 'create') {
                if (logByDateData != null) {
                  syncData['data'][table]['create'].add(logByDateData);
                }
              } else if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'first_date_last_period': pregnancy.hariPertamaHaidTerakhir, 'date': uniqueKey});
              }
            }
          } else if (table == 'contraction_timer') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'contraction_timer' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              PregnancyDailyLog? pregnancyLogs = pregnancyDailyLogs!.firstWhereOrNull((pregnancyDailyLog) => pregnancyDailyLog.riwayatKehamilanId == pregnancy?.id);
              List<ContractionTimer>? contractionTimer = pregnancyLogs?.timerKontraksi;

              if (pregnancy == null || pregnancyLogs == null) {
                continue;
              }

              var operations = operationListMap[uniqueKey]!;
              ContractionTimer? contraction = contractionTimer?.firstWhereOrNull((contraction) => contraction.id == uniqueKey);
              var contractionData = contraction?.toJson();
              contractionData?['first_date_last_period'] = pregnancy.hariPertamaHaidTerakhir;

              String finalOperation = '';

              for (var operation in operations) {
                if (finalOperation == 'create' && operation == 'delete') {
                  finalOperation = '';
                  break;
                } else {
                  finalOperation = operation;
                }
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'first_date_last_period': pregnancy.hariPertamaHaidTerakhir, 'id': uniqueKey});
              } else if (finalOperation == 'create') {
                if (contractionData != null) {
                  syncData['data'][table]['create']!.add(contractionData);
                }
              }
            }
          } else if (table == 'blood_pressure') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'blood_pressure' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              PregnancyDailyLog? pregnancyLogs = pregnancyDailyLogs!.firstWhereOrNull((pregnancyDailyLog) => pregnancyDailyLog.riwayatKehamilanId == pregnancy?.id);
              List<BloodPressure>? bloodPressures = pregnancyLogs?.tekananDarah;

              if (pregnancy == null || pregnancyLogs == null) {
                continue;
              }

              BloodPressure? bloodPressure = bloodPressures?.firstWhereOrNull((tekananDarah) => tekananDarah.id == uniqueKey);
              var operations = operationListMap[uniqueKey]!;
              var bloodPressureData = bloodPressure?.toJson();
              bloodPressureData?['first_date_last_period'] = pregnancy.hariPertamaHaidTerakhir;

              String finalOperation = '';

              bool hasCreate = false;
              bool hasDelete = false;
              bool hasUpdate = false;

              for (var operation in operations) {
                if (operation == 'create') {
                  hasCreate = true;
                  finalOperation = 'create';
                } else if (operation == 'update') {
                  hasUpdate = true;
                  if (!hasCreate) {
                    finalOperation = 'update';
                  }
                } else if (operation == 'delete') {
                  hasDelete = true;
                  if (hasCreate) {
                    finalOperation = '';
                    break;
                  } else {
                    finalOperation = 'delete';
                  }
                }
              }

              if (hasCreate && hasUpdate && !hasDelete) {
                finalOperation = 'create';
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'first_date_last_period': pregnancy.hariPertamaHaidTerakhir, 'id': uniqueKey});
              } else if (finalOperation == 'create') {
                if (bloodPressureData != null) {
                  syncData['data'][table]['create'].add(bloodPressureData);
                }
              } else if (finalOperation == 'update') {
                if (bloodPressureData != null) {
                  syncData['data'][table]['update'].add(bloodPressureData);
                }
              }
            }
          } else if (table == 'baby_kicks') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'baby_kicks' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              PregnancyDailyLog? pregnancyLogs = pregnancyDailyLogs!.firstWhereOrNull((pregnancyDailyLog) => pregnancyDailyLog.riwayatKehamilanId == pregnancy?.id);
              List<BabyKicks>? babyKicks = pregnancyLogs?.gerakanBayi;

              if (pregnancy == null || pregnancyLogs == null) {
                continue;
              }

              BabyKicks? babyKick = babyKicks?.firstWhereOrNull((kick) => kick.id == uniqueKey);
              var operations = operationListMap[uniqueKey]!;
              var babyKickData = babyKick?.toJson();
              babyKickData?['first_date_last_period'] = pregnancy.hariPertamaHaidTerakhir;

              String finalOperation = '';

              for (var operation in operations) {
                if (finalOperation == 'create' && operation == 'delete') {
                  finalOperation = '';
                  break;
                } else {
                  finalOperation = operation;
                }
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'first_date_last_period': pregnancy.hariPertamaHaidTerakhir, 'id': uniqueKey});
              } else if (finalOperation == 'create') {
                if (babyKickData != null) {
                  syncData['data'][table]['create'].add(babyKickData);
                }
              }
            }
          }
          if (syncData['data'][table]['create']?.isEmpty ?? true) {
            syncData['data'][table].remove('create');
          }
          if (syncData['data'][table]['update']?.isEmpty ?? true) {
            syncData['data'][table].remove('update');
          }
          if (syncData['data'][table]['delete']?.isEmpty ?? true) {
            syncData['data'][table].remove('delete');
          }
        }
        _logger.i(syncData);
        DataCategoryByTable? pendingDataChangesResponse = await profileRepository.resyncPendingData(syncData);

        List<PeriodHistory>? updatedPeriodHistory = pendingDataChangesResponse?.periodHistory;
        List<PregnancyHistory>? updatedPregnancyHistory = pendingDataChangesResponse?.pregnancyHistory;

        if ((updatedPeriodHistory?.length ?? 0) > 0 && updatedPeriodHistory != null) {
          for (var period in updatedPeriodHistory) {
            PeriodHistory? matchingPeriodHistory = periodHistories.firstWhereOrNull((localPeriodData) => localPeriodData.haidAwal == period.haidAwal && localPeriodData.haidAkhir == period.haidAkhir);
            if (matchingPeriodHistory != null) {
              PeriodHistory editPeriodId = matchingPeriodHistory.copyWith(remoteId: period.id);
              await _periodHistoryRepository.editPeriodHistory(editPeriodId);
            }
          }
        }

        if ((updatedPregnancyHistory?.length ?? 0) > 0 && updatedPregnancyHistory != null) {
          for (var pregnancy in updatedPregnancyHistory) {
            PregnancyHistory? matchingPregnancyHistory = pregnancyHistories.firstWhereOrNull((localPregnancyData) => localPregnancyData.hariPertamaHaidTerakhir == pregnancy.hariPertamaHaidTerakhir);
            if (matchingPregnancyHistory != null) {
              PregnancyHistory editPregnancyId = matchingPregnancyHistory.copyWith(remoteId: pregnancy.id);
              await _pregnancyHistoryRepository.editPregnancy(editPregnancyId);
            }
          }
        }
      } else {
        print("No pending sync data.");
      }
    } catch (e) {
      print("Error while preparing pending data change: $e");
      rethrow;
    }
  }

  String getUniqueKey(String table, String? dataId, String? optionalId) {
    const specialTypes = {'reminder', 'daily_log', 'weight_gain', 'pregnancy_log', 'contraction_timer', 'blood_pressure', 'baby_kicks'};

    if (specialTypes.contains(table) && optionalId != null && optionalId.isNotEmpty) {
      return optionalId;
    }

    return dataId ?? '';
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

      Map<String, dynamic> userData = {
        "profile": profile?.toJson(),
        "dailyLog": dailyLog?.toJson(),
        "periodHistory": isActualPeriodHistory.map((e) => e.toJson()).toList(),
        "pregnancyHistory": pregnancyHistory.map((e) => e.toJson()).toList(),
        "weightHistory": weightHistory.map((e) => e.toJson()).toList(),
        "pregnancyDailyLog": pregnancyDailyLog?.map((e) => e.toJson()).toList(),
      };

      // _logger.i(profile?.toJson());
      // _logger.i(dailyLog?.toJson());
      // _logger.i(isActualPeriodHistory.map((e) => e.toJson()).toList());
      // _logger.i(pregnancyHistory.map((e) => e.toJson()).toList());
      // _logger.i(weightHistory.map((e) => e.toJson()).toList());
      // _logger.i(pregnancyDailyLog?.map((e) => e.toJson()).toList());

      DataCategoryByTable? resyncDataResponse = await profileRepository.resyncData(userData);
      List<PeriodHistory>? updatedPeriodHistory = resyncDataResponse?.periodHistory;
      List<PregnancyHistory>? updatedPregnancyHistory = resyncDataResponse?.pregnancyHistory;

      if ((updatedPeriodHistory?.length ?? 0) > 0 && updatedPeriodHistory != null) {
        for (var period in updatedPeriodHistory) {
          PeriodHistory? matchingPeriodHistory = periodHistory.firstWhereOrNull((localPeriodData) => localPeriodData.haidAwal == period.haidAwal && localPeriodData.haidAkhir == period.haidAkhir);
          if (matchingPeriodHistory != null) {
            PeriodHistory editPeriodId = matchingPeriodHistory.copyWith(remoteId: period.id);
            await _periodHistoryRepository.editPeriodHistory(editPeriodId);
          }
        }
      }

      if ((updatedPregnancyHistory?.length ?? 0) > 0 && updatedPregnancyHistory != null) {
        for (var pregnancy in updatedPregnancyHistory) {
          PregnancyHistory? matchingPregnancyHistory = pregnancyHistory.firstWhereOrNull((localPregnancyData) => localPregnancyData.hariPertamaHaidTerakhir == pregnancy.hariPertamaHaidTerakhir);
          if (matchingPregnancyHistory != null) {
            PregnancyHistory editPregnancyId = matchingPregnancyHistory.copyWith(remoteId: pregnancy.id);
            await _pregnancyHistoryRepository.editPregnancy(editPregnancyId);
          }
        }
      }
    } catch (e) {
      _logger.e("Error during rebackup data: $e");
      throw Exception('Data tidak lengkap');
    }
  }

  Future<void> _syncSafe(Future<void> Function() syncFunction, {int tryError = 3}) async {
    int attempts = 0;
    while (attempts < tryError) {
      try {
        await syncFunction();
        _logger.i("Sync function $syncFunction success");
        return;
      } catch (e) {
        attempts++;
        _logger.e("Error during sync $syncFunction: $e");
        if (attempts >= tryError) {
          _logger.e("$e - All attempts failed");
          throw Exception("Sync function $syncFunction failed after $tryError attempts");
        }
      }
    }
  }
}
