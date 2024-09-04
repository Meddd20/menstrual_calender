import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/pregnancy_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_history_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/pregnancy_log_repository.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class PregnancyLogService {
  final Logger _logger = Logger();
  final PregnancyLogRepository _pregnancyLogRepository;
  final PregnancyHistoryRepository _pregnancyHistoryRepository;
  final StorageService storageService = StorageService();

  PregnancyLogService(this._pregnancyLogRepository, this._pregnancyHistoryRepository);

  Future<void> upsertPregnancyDailyLog(DateTime date, Map<String, dynamic>? pregnancySymptoms, double? temperature, String? notes) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return;
      }

      DataHarianKehamilan newPregnancyDailyLog = DataHarianKehamilan(
        date: formatDate(date),
        pregnancySymptoms: PregnancySymptoms.fromJson(pregnancySymptoms ?? {}),
        temperature: temperature.toString(),
        notes: notes,
      );

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);

      if (existingPregnancyLog != null) {
        List<DataHarianKehamilan>? updatedDataHarianKehamilan;

        if (existingPregnancyLog.dataHarianKehamilan != null) {
          updatedDataHarianKehamilan = existingPregnancyLog.dataHarianKehamilan?.where((item) => formatDateStr(item.date) != formatDateStr(newPregnancyDailyLog.date)).toList();
        } else {
          updatedDataHarianKehamilan = [];
        }

        updatedDataHarianKehamilan?.add(newPregnancyDailyLog);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          dataHarianKehamilan: updatedDataHarianKehamilan,
          updatedAt: DateTime.now().toString(),
        );

        print("not finalized update ${updatedPregnancyLog.toJson()}");
        print("existingpregnancy log${existingPregnancyLog.toJson()}");

        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);

        PregnancyDailyLog? newPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
        print("updated pregnancy log${newPregnancyLog?.toJson()}");
      } else {
        PregnancyDailyLog newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          dataHarianKehamilan: [newPregnancyDailyLog],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );

        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deletePregnancyDailyLog(String date) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);

      if (existingPregnancyLog == null) {
        _logger.e('Pregnancy log data is null');
        return;
      }

      List<DataHarianKehamilan> updatedDataHarianKehamilan = existingPregnancyLog.dataHarianKehamilan!.where((item) => formatDateStr(item.date) != formatDateStr(date)).toList();

      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
        dataHarianKehamilan: updatedDataHarianKehamilan,
        updatedAt: DateTime.now().toString(),
      );

      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<DataHarianKehamilan?> getPregnancyLogByDate(String date) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);

      if (existingPregnancyLog != null) {
        DataHarianKehamilan? dataHarianKehamilanByDate = existingPregnancyLog.dataHarianKehamilan?.firstWhereOrNull(
          (item) => formatDateStr(item.date) == formatDateStr(date),
        );

        if (dataHarianKehamilanByDate != null) {
          return dataHarianKehamilanByDate;
        } else {
          return DataHarianKehamilan(date: date, pregnancySymptoms: _defaultPregnancySymptoms(), notes: "", temperature: "");
        }
      } else {
        return DataHarianKehamilan(date: date, pregnancySymptoms: _defaultPregnancySymptoms(), notes: "", temperature: "");
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      return DataHarianKehamilan(date: date, pregnancySymptoms: _defaultPregnancySymptoms(), notes: "", temperature: "");
    }
  }

  Future<DailyLogTagsData> getPregnancyLogByTags(String tags) async {
    List<String> allowedTags = ["pregnancySymptoms", "notes", "temperature"];

    if (!allowedTags.contains(tags)) {
      throw Exception("Invalid tags parameter.");
    }

    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    if (currentPregnancyData == null) {
      _logger.e('Current pregnancy data is null');
      throw Exception("Current pregnancy data is null");
    }

    PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
    List<DataHarianKehamilan>? logDataKehamilan = existingPregnancyLog?.dataHarianKehamilan;

    if (existingPregnancyLog != null && logDataKehamilan != null) {
      Map<String, List<String>> logs = {};

      DateTime now = DateTime.now();
      DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
      DateTime threeMonthsAgo = now.subtract(Duration(days: 90));
      DateTime sixMonthsAgo = now.subtract(Duration(days: 180));
      DateTime oneYearAgo = now.subtract(Duration(days: 365));

      logDataKehamilan.forEach(
        (pregnancyLog) {
          String? logDate = pregnancyLog.date;
          dynamic tagValue = pregnancyLog.toJson()[tags];

          if (tags == "pregnancySymptoms") {
            Map<String, dynamic>? tagMap = pregnancyLog.toJson()[tags];
            if (tagMap != null && tagMap.isNotEmpty) {
              List<String> trueTags = tagMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
              if (trueTags.isNotEmpty) {
                logs[logDate] = trueTags;
              }
            }
          } else {
            if (tags == "temperature") {
              if (tagValue != null && double.tryParse(tagValue) != null && double.parse(tagValue) > 1) {
                logs[logDate] = [tagValue.toString()];
              }
            } else {
              if (tagValue != null) {
                logs[logDate] = [tagValue.toString()];
              }
            }
          }
        },
      );

      var sortedLogs = Map.fromEntries(logs.entries.toList()..sort((a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key))));
      sortedLogs.removeWhere((key, value) => value.isEmpty);

      Map<String, int> percentage30Days = findOccurrences(sortedLogs, thirtyDaysAgo);
      Map<String, int> percentage3Months = findOccurrences(sortedLogs, threeMonthsAgo);
      Map<String, int> percentage6Months = findOccurrences(sortedLogs, sixMonthsAgo);
      Map<String, int> percentage1Year = findOccurrences(sortedLogs, oneYearAgo);

      return DailyLogTagsData(
        tags: tags,
        logs: sortedLogs,
        percentage30Days: percentage30Days,
        percentage3Months: percentage3Months,
        percentage6Months: percentage6Months,
        percentage1Year: percentage1Year,
      );
    } else {
      return DailyLogTagsData(
        tags: tags,
        logs: {},
        percentage30Days: {},
        percentage3Months: {},
        percentage6Months: {},
        percentage1Year: {},
      );
    }
  }

  Map<String, int> findOccurrences(Map<String, List<String>> tagsValues, DateTime startDate) {
    Map<String, int> occurrences = {};

    tagsValues.forEach((date, data) {
      DateTime logDate = DateTime.parse(date);
      if (logDate.isAfter(startDate) || logDate.isAtSameMomentAs(startDate)) {
        data.forEach((value) {
          if (occurrences.containsKey(value)) {
            occurrences[value] = occurrences[value]! + 1;
          } else {
            occurrences[value] = 1;
          }
        });
      }
    });

    return occurrences;
  }

  Future<void> addBloodPressure(BloodPressure bloodPressure) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];

      if (existingPregnancyLog != null) {
        tekananDarah.add(bloodPressure);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          tekananDarah: tekananDarah,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      } else {
        PregnancyDailyLog newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          tekananDarah: [bloodPressure],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> editBloodPressure(BloodPressure bloodPressure) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];

      if (existingPregnancyLog != null) {
        int index = tekananDarah.indexWhere((element) => element.id == bloodPressure.id);
        if (index != -1) {
          tekananDarah[index] = bloodPressure;
          PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
            tekananDarah: tekananDarah,
            updatedAt: DateTime.now().toString(),
          );
          await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
        }
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteBloodPressure(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];

      if (existingPregnancyLog != null) {
        tekananDarah.removeWhere((element) => element.id == id);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          tekananDarah: tekananDarah,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<List<BloodPressure>> getAllBloodPressure() async {
    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    if (currentPregnancyData == null) {
      _logger.e('Current pregnancy data is null');
      throw Exception("Current pregnancy data is null");
    }
    PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
    List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];
    tekananDarah.sort((a, b) => b.datetime.compareTo(a.datetime));
    return tekananDarah;
  }

  Future<void> addContractionTimer(String id, String waktuMulai, int durasi) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<ContractionTimer>? timerKontraksi = existingPregnancyLog?.timerKontraksi ?? [];
      DateTime time = DateTime.parse(waktuMulai);
      DateTime oneHourAgo = time.subtract(Duration(hours: 1));

      List<ContractionTimer> timerKontraksiWithin1Hour = timerKontraksi.where((contraction) {
        DateTime contractionTimeStart = DateTime.parse(contraction.timeStart);
        return contractionTimeStart.isAfter(oneHourAgo) && contractionTimeStart.isBefore(time);
      }).toList();
      timerKontraksiWithin1Hour.sort((a, b) => b.timeStart.compareTo(a.timeStart));
      ContractionTimer? contractionTimerWithin1Hour = timerKontraksiWithin1Hour.isNotEmpty ? timerKontraksiWithin1Hour.first : null;

      ContractionTimer latestContractionData;
      if (contractionTimerWithin1Hour != null) {
        DateTime previousTimeStart = DateTime.parse(contractionTimerWithin1Hour.timeStart);
        int intervalInSeconds = time.difference(previousTimeStart).inSeconds;
        latestContractionData = ContractionTimer(
          id: id,
          timeStart: waktuMulai,
          duration: durasi,
          interval: intervalInSeconds,
        );
      } else {
        latestContractionData = ContractionTimer(
          id: id,
          timeStart: waktuMulai,
          duration: durasi,
        );
      }

      if (existingPregnancyLog != null) {
        timerKontraksi.add(latestContractionData);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          timerKontraksi: timerKontraksi,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      } else {
        PregnancyDailyLog newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          timerKontraksi: [latestContractionData],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteContractionTimer(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<ContractionTimer>? timerKontraksi = existingPregnancyLog?.timerKontraksi ?? [];

      ContractionTimer? deletedContraction = timerKontraksi.firstWhereOrNull((contraction) => contraction.id == id);
      int deletedContractionIndex = timerKontraksi.indexWhere((contraction) => contraction.id == id);
      ContractionTimer? previousContraction = deletedContractionIndex > 0 ? timerKontraksi[deletedContractionIndex - 1] : null;
      ContractionTimer? nextContraction = deletedContractionIndex < timerKontraksi.length - 1 ? timerKontraksi[deletedContractionIndex + 1] : null;

      if (deletedContraction != null && deletedContraction.interval == null && nextContraction != null) {
        timerKontraksi[deletedContractionIndex + 1] = nextContraction.copyWith(interval: null);
      }

      if (previousContraction != null && nextContraction != null) {
        DateTime previousTimeStart = DateTime.parse(previousContraction.timeStart);
        DateTime currentTimeStart = DateTime.parse(nextContraction.timeStart);
        int intervalInSeconds = currentTimeStart.difference(previousTimeStart).inSeconds;
        timerKontraksi[deletedContractionIndex + 1] = nextContraction.copyWith(interval: intervalInSeconds);
      }

      if (existingPregnancyLog != null) {
        timerKontraksi.removeWhere((element) => element.id == id);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          timerKontraksi: timerKontraksi,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<List<ContractionTimer>> getAllContractionTimer() async {
    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    if (currentPregnancyData == null) {
      _logger.e('Current pregnancy data is null');
      throw Exception("Current pregnancy data is null");
    }
    PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
    List<ContractionTimer>? timerKontraksi = existingPregnancyLog?.timerKontraksi ?? [];
    timerKontraksi.sort((a, b) => b.timeStart.compareTo(a.timeStart));
    return timerKontraksi;
  }

  Future<void> addKicksCounter(String id, String datetime) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BabyKicks>? gerakanBayi = existingPregnancyLog?.gerakanBayi ?? [];

      gerakanBayi.sort((a, b) => DateTime.parse(b.datetimeStart).compareTo(DateTime.parse(a.datetimeStart)));

      DateTime newKickDateTime = DateTime.parse(datetime);

      if (gerakanBayi.isNotEmpty) {
        BabyKicks lastKickData = gerakanBayi.first;
        DateTime lastKickDateTime = DateTime.parse(lastKickData.datetimeStart);

        if (newKickDateTime.difference(lastKickDateTime).inSeconds > 3600) {
          BabyKicks newKick = BabyKicks(
            id: id,
            datetimeStart: datetime,
            datetimeEnd: datetime,
            totalKicks: 1,
          );
          gerakanBayi.add(newKick);
        } else {
          lastKickData = lastKickData.copyWith(
            datetimeEnd: datetime,
            totalKicks: lastKickData.totalKicks + 1,
          );
          gerakanBayi[0] = lastKickData;
        }
      } else {
        BabyKicks newKick = BabyKicks(
          id: id,
          datetimeStart: datetime,
          datetimeEnd: datetime,
          totalKicks: 1,
        );
        gerakanBayi.add(newKick);
      }

      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog?.copyWith(
            gerakanBayi: gerakanBayi,
            updatedAt: DateTime.now().toString(),
          ) ??
          PregnancyDailyLog(
            userId: userId,
            riwayatKehamilanId: currentPregnancyData.id!,
            gerakanBayi: gerakanBayi,
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          );

      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> addKickData(BabyKicks babyKickData) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BabyKicks>? gerakanBayi = existingPregnancyLog?.gerakanBayi ?? [];

      if (gerakanBayi.isNotEmpty) {
        gerakanBayi.add(babyKickData);
      } else {
        gerakanBayi = [babyKickData];
      }

      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog?.copyWith(
            gerakanBayi: gerakanBayi,
            updatedAt: DateTime.now().toString(),
          ) ??
          PregnancyDailyLog(
            userId: userId,
            riwayatKehamilanId: currentPregnancyData.id!,
            gerakanBayi: gerakanBayi,
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          );

      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteKicksCounter(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BabyKicks>? gerakanBayi = existingPregnancyLog?.gerakanBayi ?? [];

      if (existingPregnancyLog != null) {
        gerakanBayi.removeWhere((element) => element.id == id);
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          gerakanBayi: gerakanBayi,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<List<BabyKicks>> getAllKicksCounter() async {
    int userId = storageService.getAccountLocalId();
    PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

    if (currentPregnancyData == null) {
      _logger.e('Current pregnancy data is null');
      throw Exception("Current pregnancy data is null");
    }
    PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
    List<BabyKicks>? gerakanBayi = existingPregnancyLog?.gerakanBayi ?? [];
    gerakanBayi.sort((a, b) => b.datetimeStart.compareTo(a.datetimeStart));
    return gerakanBayi;
  }

  PregnancySymptoms _defaultPregnancySymptoms() {
    return PregnancySymptoms(
      achesAndPains: false,
      abdominalPressure: false,
      abdominalStretching: false,
      babyKicks: false,
      backPain: false,
      backaches: false,
      breastEnlargement: false,
      breastSoreness: false,
      breastSwelling: false,
      breastTenderness: false,
      breathlessness: false,
      carpalTunnelSyndrome: false,
      changesInLibido: false,
      clumsiness: false,
      constipation: false,
      cervicalDilation: false,
      decreasedLibido: false,
      darkeningOfSkin: false,
      dizziness: false,
      dryEyes: false,
      dryMouth: false,
      drySkin: false,
      easierBreathing: false,
      excessiveSalivation: false,
      fastGrowingHairAndNails: false,
      fatigue: false,
      foodAversions: false,
      foodCravings: false,
      frequentHeadaches: false,
      frequentUrination: false,
      generalDiscomfort: false,
      gumSensitivity: false,
      hairGrowthChanges: false,
      heartPalpitations: false,
      heartburn: false,
      hipPain: false,
      hipGroinAndAbdominalPain: false,
      hemorrhoids: false,
      increasedAppetite: false,
      increasedSaliva: false,
      increasedThirst: false,
      increasedUrgeToPush: false,
      increasedVaginalDischarge: false,
      insomnia: false,
      itchinessInHandsAndFeet: false,
      legCramps: false,
      legSwelling: false,
      leakyBreasts: false,
      looseLigaments: false,
      lossOfMucusPlug: false,
      lowerBackPain: false,
      moodSwings: false,
      nasalCongestion: false,
      nauseaAndVomiting: false,
      numbnessOrTingling: false,
      pelvicPain: false,
      pelvicPainAsBabyDescends: false,
      pelvicPressure: false,
      pregnancyBrain: false,
      pregnancyGlow: false,
      roundLigamentPain: false,
      skinChanges: false,
      shortnessOfBreath: false,
      spottingAfterSex: false,
      stuffyNose: false,
      stretchMarks: false,
      swellingInHandsAndFeet: false,
      swollenFeet: false,
      vividDreams: false,
      varicoseVeins: false,
      waterBreaking: false,
    );
  }
}
