import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_weight_gain.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_data_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/period_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/pregnancy_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/period_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/weight_history_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/services/period_history_service.dart';
import 'package:periodnpregnancycalender/app/services/pregnancy_history_service.dart';
import 'package:periodnpregnancycalender/app/services/weight_history_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class SyncDataService {
  final PeriodHistoryRepository _periodHistoryRepository;
  final PregnancyHistoryRepository _pregnancyHistoryRepository;
  final WeightHistoryRepository _weightHistoryRepository;
  final LocalProfileRepository _localProfileRepository;
  final SyncDataRepository _syncDataRepository;
  final LocalLogRepository _localLogRepository;

  final PeriodHistoryService periodHistoryService;
  final PregnancyHistoryService pregnancyHistoryService;
  final WeightHistoryService weightHistoryService;
  final LogService logService;

  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  late final ProfileRepository profileRepository = ProfileRepository(apiService, databaseHelper);
  late final PregnancyRepository pregnancyRepository = PregnancyRepository(apiService);
  late final PeriodRepository periodRepository = PeriodRepository(apiService);
  late final LogRepository logRepository = LogRepository(apiService);

  final Logger _logger = Logger();

  SyncDataService(this._weightHistoryRepository, this._periodHistoryRepository, this._pregnancyHistoryRepository, this._localProfileRepository, this._syncDataRepository, this._localLogRepository, this.periodHistoryService, this.weightHistoryService, this.pregnancyHistoryService, this.logService);

  Future<void> syncData() async {
    try {
      int userId = storageService.getAccountLocalId();
      User? profile = await _localProfileRepository.getProfile();
      DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);
      List<PeriodHistory>? periodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
      List<PregnancyHistory>? pregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
      List<WeightHistory>? weightHistory = await _weightHistoryRepository.getWeightHistory(userId);

      DataCategoryByTable? dataFetchFromAPI = await profileRepository.fetchSyncDataFromApi();
      User? profileFetchFromAPI = dataFetchFromAPI?.user;
      DailyLog? dailyLogFetchFromAPI = dataFetchFromAPI?.logHistory;
      List<PeriodHistory>? periodHistoryFetchFromAPI = dataFetchFromAPI?.periodHistory;
      List<PregnancyHistory>? pregnancyHistoryFetchFromAPI = dataFetchFromAPI?.pregnancyHistory;
      List<WeightHistory>? weightHistoryFetchFromAPI = dataFetchFromAPI?.weightGainHistory;

      print(profileFetchFromAPI?.toJson());
      print(dailyLogFetchFromAPI?.toJson());
      print(periodHistoryFetchFromAPI?.toList());

      await _syncUserData(profile, profileFetchFromAPI, userId);
      await _syncDailyLogData(dailyLog, dailyLogFetchFromAPI, userId);
      await _syncPeriodHistoryData(periodHistory, periodHistoryFetchFromAPI, userId);
      await _syncPregnancyHistoryData(pregnancyHistory, pregnancyHistoryFetchFromAPI, userId);
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
          nama: profile.nama,
          email: profile.email,
          tanggalLahir: profile.tanggalLahir,
          isPregnant: profile.isPregnant,
        );
        await _syncDataRepository.fetchNewlySyncUserData(syncUserProfile);
      }
    }
  }

  Future<void> _syncDailyLogData(DailyLog? localDailyLog, DailyLog? fetchedDailyLog, int userId) async {
    List<DataHarian>? localDataHarian = localDailyLog?.dataHarian;
    List<Reminders>? localReminders = localDailyLog?.pengingat;
    List<DataHarian>? fetchedDataHarian = fetchedDailyLog?.dataHarian;
    List<Reminders>? fetchedReminders = fetchedDailyLog?.pengingat;

    if (fetchedDailyLog != null) {
      if (localDataHarian != null && localReminders != null) {
        // Sync DataHarian
        if (fetchedDataHarian != null) {
          for (var fetchedData in fetchedDataHarian) {
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
              if (localReminder.remoteId == fetchedReminders[i].id && localReminder.title == fetchedReminders[i].title && localReminder.datetime == fetchedReminders[i].datetime && localReminder.description == fetchedReminders[i].description) {
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
              if (localReminder.remoteId == fetchedReminder.id && localReminder.title == fetchedReminder.title && localReminder.datetime == fetchedReminder.datetime && localReminder.description == fetchedReminder.description) {
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
              remoteId: fetchedReminders[index].id ?? "",
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
          for (var fetchedData in fetchedDataHarian) {
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
              remoteId: fetchedReminder.id,
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
          await periodHistoryService.addPeriod(
            periodHistory.id!,
            periodHistory.haidAwal!,
            periodHistory.haidAkhir!,
            periodHistory.lamaSiklus!,
          );
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
            isActualPeriodHistoryFromAPI[index].id!,
            isActualPeriodHistoryFromAPI[index].haidAwal!,
            isActualPeriodHistoryFromAPI[index].haidAkhir!,
            isActualPeriodHistoryFromAPI[index].lamaSiklus!,
          );
        }
      }
    }
  }

  Future<void> _syncPregnancyHistoryData(List<PregnancyHistory>? pregnancyHistory, List<PregnancyHistory>? pregnancyHistoryFetchFromAPI, int userId) async {
    if (pregnancyHistoryFetchFromAPI != null) {
      if (pregnancyHistory == null || pregnancyHistory.isEmpty) {
        await _syncDataRepository.fetchNewlySyncPregnancyHistoryData(pregnancyHistoryFetchFromAPI, userId);
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
            await _pregnancyHistoryRepository.deletePregnancy(userId);
          }
        }

        for (var index in notFoundInLocal) {
          PregnancyHistory addPregnancyData = pregnancyHistoryFetchFromAPI[index];
          await _pregnancyHistoryRepository.addPregnancyData(
            addPregnancyData,
            userId,
            remoteId: addPregnancyData.id,
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
          await weightHistoryService.addWeeklyWeightGain(
            DateTime.parse(weightHistoryFetchFromAPI[index].tanggalPencatatan!),
            weightHistoryFetchFromAPI[index].beratBadan!,
            weightHistoryFetchFromAPI[index].mingguKehamilan!,
          );
        }
      }
    }
  }

  Future<void> pendingDataChange() async {
    try {
      int userId = storageService.getAccountLocalId();
      List<SyncLog> getAllSyncLogData = await _syncDataRepository.getAllSyncLogData();

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
                    var reminderAdded = await logRepository.storeReminder(
                      data['title'],
                      data['description'],
                      data['dateTime'],
                    );

                    await logService.addReminder(Reminders(
                      remoteId: reminderAdded['data']['id'],
                      title: data['title'],
                      description: data['description'],
                      datetime: data['dateTime'],
                    ));
                    success = true;
                  } else if (syncLog.operation == "editReminder") {
                    await logRepository.editReminder(
                      data['id'],
                      data['title'],
                      data['description'],
                      data['dateTime'],
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
                    List<PeriodHistory>? periodAdded = await periodRepository.storePeriod(
                      data['periods'],
                      data['periodCycle'],
                      null,
                    );

                    if (periodAdded != null) {
                      for (var newPeriodAdd in periodAdded) {
                        List<PeriodHistory> getAllPeriodHistory = await _periodHistoryRepository.getPeriodHistory(userId);
                        PeriodHistory? localPeriodAdded = getAllPeriodHistory.firstWhere((period) => period.haidAwal == newPeriodAdd.haidAwal && period.haidAkhir == newPeriodAdd.haidAkhir);
                        if (localPeriodAdded != null) {
                          PeriodHistory editPeriodId = localPeriodAdded.copyWith(remoteId: newPeriodAdd.id);
                          await _periodHistoryRepository.editPeriodHistory(editPeriodId);
                        }
                      }
                    }

                    success = true;
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
                    var pregnancyAdded = await pregnancyRepository.pregnancyBegin(
                      data['firstDayLastMenstruation'],
                      null,
                    );

                    List<PregnancyHistory> getAllPregnancyHistory = await _pregnancyHistoryRepository.getAllPregnancyHistory(userId);
                    PregnancyHistory? localPregnancyAdded = getAllPregnancyHistory.firstWhere((pregnancyData) => pregnancyData.hariPertamaHaidTerakhir == data['firstDayLastMenstruation']) ?? null;
                    if (localPregnancyAdded != null) {
                      PregnancyHistory editPregnancyId = localPregnancyAdded.copyWith(remoteId: pregnancyAdded["data"]["id"]);
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
      }
    } catch (e) {
      _logger.e("Error during sync data: $e");
      throw Exception('Data tidak lengkap');
    }
  }
}
