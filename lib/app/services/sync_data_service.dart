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

      await _syncUserData(profile, profileFetchFromAPI, userId);
      await _syncDailyLogData(dailyLog, dailyLogFetchFromAPI, userId);
      await _syncPeriodHistoryData(periodHistory, periodHistoryFetchFromAPI, userId);
      await _syncPregnancyHistoryData(pregnancyHistory, pregnancyHistoryFetchFromAPI, userId);
      await _syncPregnancyDailyLogData(pregnancyDailyLog, pregnancyDailyLogFetchFromAPI, userId);
      await _syncWeightHistoryData(weightHistory, weightHistoryFetchFromAPI, userId);
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

                operationListMap[dataId]!.add(operation);
              }
            }
          }

          if (table == 'user') {
            var profileData = {
              'name': profile?.nama,
              'birthday': profile?.tanggalLahir,
              'isPregnant': profile?.isPregnant,
            };
            syncData['data'][table]['update'].add(profileData);
          } else if (table == 'period') {
            for (var uniqueKey in operationListMap.keys) {
              var operations = operationListMap[uniqueKey]!;
              PeriodHistory? periodHistory = periodHistories.firstWhereOrNull((period) => period.id == uniqueKey);
              var periodData = {
                'period_id': periodHistory?.remoteId,
                'first_period': periodHistory?.haidAwal,
                'last_period': periodHistory?.haidAkhir,
                'period_cycle': periodHistory?.lamaSiklus,
              };

              String finalOperation = '';

              for (var operation in operations) {
                if (operation == 'update') {
                  finalOperation = 'update';
                } else if (finalOperation != 'update' && operation == 'create') {
                  finalOperation = 'create';
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
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                if (operation == 'create') {
                  finalOperation = 'create';
                } else if (operation == 'delete') {
                  finalOperation = 'delete';
                }
              }

              if (finalOperation == 'create') {
                DataHarian? logByDate = dailyLogs!.firstWhereOrNull(
                  (log) => log.date != null && DateTime.parse(log.date!).isAtSameMomentAs(DateTime.parse(uniqueKey)),
                );

                if (logByDate != null) {
                  var logData = {
                    'date': logByDate.date,
                    'sex_activity': logByDate.sexActivity,
                    'bleeding_flow': logByDate.bleedingFlow,
                    'symptoms': logByDate.symptoms?.toJson(),
                    'vaginal_discharge': logByDate.vaginalDischarge,
                    'moods': logByDate.moods?.toJson(),
                    'others': logByDate.others?.toJson(),
                    'physical_activity': logByDate.physicalActivity?.toJson(),
                    'temperature': logByDate.temperature,
                    'weight': logByDate.weight,
                    'notes': logByDate.notes,
                  };

                  syncData['data'][table]['create'].add(logData);
                }
              } else if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'date': uniqueKey});
              }
            }
          } else if (table == 'reminder') {
            for (var uniqueKey in operationListMap.keys) {
              Reminders? data = reminders?.firstWhereOrNull((reminder) => reminder.id == uniqueKey);
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                if (finalOperation == 'create' && operation == 'delete') {
                  finalOperation = '';
                  break;
                } else if (finalOperation == 'update' && operation == 'delete') {
                  finalOperation = 'delete';
                } else if (finalOperation == 'create' && operation == 'update') {
                  continue;
                } else {
                  finalOperation = operation;
                }
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'id': uniqueKey});
              } else if (finalOperation == 'create') {
                syncData['data'][table]['create'].add(data);
              } else if (finalOperation == 'update') {
                syncData['data'][table]['update'].add(data);
              }
            }
          } else if (table == 'pregnancy') {
            for (var uniqueKey in operationListMap.keys) {
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == uniqueKey);
              User? profile = await _localProfileRepository.getProfile();
              var pregnancyData = pregnancy?.toJson();
              pregnancyData?['isPregnant'] = profile?.isPregnant;
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                if (finalOperation == 'create' && operation == 'delete') {
                  finalOperation = '';
                  break;
                } else if (finalOperation == 'update' && operation == 'delete') {
                  finalOperation = 'delete';
                } else if (finalOperation == 'create' && operation == 'update') {
                  continue;
                } else {
                  finalOperation = operation;
                }
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'pregnancy_id': uniqueKey});
              } else if (finalOperation == 'create') {
                syncData['data'][table]['create'].add(pregnancyData);
              } else if (finalOperation == 'update') {
                syncData['data'][table]['update'].add(pregnancyData);
              }
            }
          } else if (table == 'weight_gain') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'pregnancy_log' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? weightPregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              WeightHistory? data = weightHistories.firstWhereOrNull((weight) => weight.tanggalPencatatan == uniqueKey);
              if (data == null) {
                continue;
              }
              var operations = operationListMap[uniqueKey]!;

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
                syncData['data'][table]['delete'].add({'tanggal_pencatatan': uniqueKey});
              } else if (finalOperation == 'create' || finalOperation == 'init') {
                var pregnancyLog = {
                  'berat_badan': data.beratBadan,
                  'minggu_kehamilan': data.mingguKehamilan,
                  'tanggal_pencatatan': data.tanggalPencatatan,
                  'weight_gain': data.pertambahanBerat,
                  'first_date_last_period': weightPregnancy?.hariPertamaHaidTerakhir,
                };

                syncData['data'][table]['create'].add(pregnancyLog);

                var pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == data.riwayatKehamilanId);

                if (pregnancy != null) {
                  var alreadyInUpdateOrCreate = syncData['data']['pregnancy']['update'].any((existingPregnancy) => existingPregnancy.id == pregnancy.id) || syncData['data']['pregnancy']['create'].any((existingPregnancy) => existingPregnancy.id == pregnancy.id);

                  if (!alreadyInUpdateOrCreate) {
                    syncData['data']['pregnancy']['update'].add(pregnancy);
                  }
                }
              }
            }
          } else if (table == 'pregnancy_log') {
            for (var uniqueKey in operationListMap.keys) {
              var dataSyncLog = syncLogs.firstWhereOrNull((syncLog) => syncLog.tableName == 'pregnancy_log' && syncLog.optionalId == uniqueKey);
              PregnancyHistory? pregnancy = pregnancyHistories.firstWhereOrNull((pregnancy) => pregnancy.id == dataSyncLog?.dataId);
              PregnancyDailyLog? pregnancyLogs = pregnancyDailyLogs!.firstWhereOrNull((pregnancyDailyLog) => pregnancyDailyLog.riwayatKehamilanId == pregnancy?.id);
              List<DataHarianKehamilan>? pregnancyLog = pregnancyLogs?.dataHarianKehamilan;

              if (pregnancy == null || pregnancyLogs == null) {
                continue;
              }

              DataHarianKehamilan? logByDate = pregnancyLog!.firstWhereOrNull(
                (log) => DateTime.parse(log.date).isAtSameMomentAs(DateTime.parse(uniqueKey)),
              );
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                if (operation == 'create') {
                  finalOperation = 'create';
                } else if (operation == 'delete') {
                  finalOperation = 'delete';
                }
              }

              if (finalOperation == 'create') {
                var pregnancyLog = {
                  'date': logByDate?.date,
                  'pregnancy_symptoms': logByDate?.pregnancySymptoms?.toJson(),
                  'temperature': logByDate?.temperature,
                  'notes': logByDate?.notes,
                  'first_date_last_period': pregnancy.hariPertamaHaidTerakhir,
                };

                syncData['data'][table]['create'].add(pregnancyLog);
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

              ContractionTimer? contraction = contractionTimer?.firstWhereOrNull((contraction) => contraction.id == uniqueKey);
              var operations = operationListMap[uniqueKey]!;

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
                var contractionData = {
                  'id': contraction?.id,
                  'waktu_mulai': contraction?.timeStart,
                  'durasi': contraction?.duration,
                  'first_date_last_period': pregnancy.hariPertamaHaidTerakhir,
                };

                syncData['data'][table]['create']!.add(contractionData);
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
              var bloodPressureData = {
                'id': bloodPressure?.id,
                'tekanan_sistolik': bloodPressure?.systolicPressure,
                'tekanan_diastolik': bloodPressure?.diastolicPressure,
                'detak_jantung': bloodPressure?.heartRate,
                'datetime': bloodPressure?.datetime,
                'first_date_last_period': pregnancy.hariPertamaHaidTerakhir,
              };
              var operations = operationListMap[uniqueKey]!;

              String finalOperation = '';

              for (var operation in operations) {
                if (finalOperation == 'create' && operation == 'delete') {
                  finalOperation = '';
                  break;
                } else if (finalOperation == 'update' && operation == 'delete') {
                  finalOperation = 'delete';
                } else if (finalOperation == 'create' && operation == 'update') {
                  continue;
                } else {
                  finalOperation = operation;
                }
              }

              if (finalOperation == 'delete') {
                syncData['data'][table]['delete'].add({'first_date_last_period': pregnancy.hariPertamaHaidTerakhir, 'id': uniqueKey});
              } else if (finalOperation == 'create') {
                syncData['data'][table]['create'].add(bloodPressureData);
              } else if (finalOperation == 'update') {
                syncData['data'][table]['update'].add(bloodPressureData);
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
                var babyKickData = {
                  'id': babyKick?.id,
                  'waktu_mulai': babyKick?.datetimeStart,
                  'waktu_selesai': babyKick?.datetimeEnd,
                  'jumlah_gerakan': babyKick?.totalKicks,
                  'first_date_last_period': pregnancy.hariPertamaHaidTerakhir,
                };

                syncData['data'][table]['create'].add(babyKickData);
              }
            }
          }
        }
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
    const specialTypes = {'weight_gain', 'pregnancy_log', 'contraction_timer', 'blood_pressure', 'baby_kicks'};

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
        "profile": profile,
        "dailyLog": dailyLog,
        "periodHistory": isActualPeriodHistory,
        "pregnancyHistory": pregnancyHistory,
        "weightHistory": weightHistory,
        "pregnancyDailyLog": pregnancyDailyLog,
      };

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
}
