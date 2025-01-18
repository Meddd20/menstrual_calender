import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class PregnancyLogService {
  final Logger _logger = Logger();
  final StorageService storageService = StorageService();

  late final PregnancyLogRepository _pregnancyLogRepository = PregnancyLogRepository();
  late final PregnancyHistoryRepository _pregnancyHistoryRepository = PregnancyHistoryRepository();

  Future<PregnancyDailyLog?> upsertPregnancyDailyLog(
    DateTime date,
    Map<String, dynamic>? pregnancySymptoms,
    double? temperature,
    String? notes,
    double? fundusUteriHeight,
    int? fetalHeartRate,
    String? examinationMethod,
    String? fetalPosition,
    String? placentaCondiion,
    int? fetalWeight,
  ) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      PregnancyDailyLog newPregnancyLog;

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      DataHarianKehamilan newPregnancyDailyLog = DataHarianKehamilan(
        date: formatDate(date),
        pregnancySymptoms: PregnancySymptoms.fromJson(pregnancySymptoms ?? {}),
        temperature: temperature.toString(),
        notes: notes,
        fundusUteriHeight: fundusUteriHeight,
        fetalHeartRate: fetalHeartRate,
        examinationMethod: examinationMethod,
        fetalPosition: fetalPosition,
        placentaCondition: placentaCondiion,
        fetalWeight: fetalWeight,
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

        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
        newPregnancyLog = updatedPregnancyLog;
      } else {
        newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          dataHarianKehamilan: [newPregnancyDailyLog],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );

        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }

      return newPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<PregnancyDailyLog?> deletePregnancyDailyLog(String date) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);

      if (existingPregnancyLog == null) {
        _logger.e('Pregnancy log data is null');
        return null;
      }

      List<DataHarianKehamilan> updatedDataHarianKehamilan = existingPregnancyLog.dataHarianKehamilan!.where((item) => formatDateStr(item.date) != formatDateStr(date)).toList();

      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
        dataHarianKehamilan: updatedDataHarianKehamilan,
        updatedAt: DateTime.now().toString(),
      );

      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);

      return updatedPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
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
          return DataHarianKehamilan(
            date: date,
            pregnancySymptoms: _defaultPregnancySymptoms(),
            notes: "",
            temperature: "",
            fundusUteriHeight: null,
            fetalHeartRate: null,
            examinationMethod: "",
            fetalPosition: "",
            placentaCondition: "",
            fetalWeight: null,
          );
        }
      } else {
        return DataHarianKehamilan(
          date: date,
          pregnancySymptoms: _defaultPregnancySymptoms(),
          notes: "",
          temperature: "",
          fundusUteriHeight: null,
          fetalHeartRate: null,
          examinationMethod: "",
          fetalPosition: "",
          placentaCondition: "",
          fetalWeight: null,
        );
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      return DataHarianKehamilan(
        date: date,
        pregnancySymptoms: _defaultPregnancySymptoms(),
        notes: "",
        temperature: "",
        fundusUteriHeight: null,
        fetalHeartRate: null,
        examinationMethod: "",
        fetalPosition: "",
        placentaCondition: "",
        fetalWeight: null,
      );
    }
  }

  Future<DailyLogTagsData> getPregnancyLogByTags(BuildContext context, String tags) async {
    List<String> allowedTags = ["pregnancySymptoms", "notes", "temperature", "fundusUteriHeight", "fetalHeartRate", "pregnancyUSG"];

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
            Map<String, dynamic>? tagMap = pregnancyLog.pregnancySymptoms?.toJson();
            if (tagMap != null && tagMap.isNotEmpty) {
              List<String> trueTags = tagMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
              if (trueTags.isNotEmpty) {
                logs[logDate] = trueTags;
              }
            }
          } else if (tags == "fundusUteriHeight") {
            double? height = pregnancyLog.fundusUteriHeight;
            if (height != null) {
              logs[logDate] = [height.toString()];
            }
          } else if (tags == "fetalHeartRate") {
            int? heartRate = pregnancyLog.fetalHeartRate;
            String? method = pregnancyLog.examinationMethod;
            if (heartRate != null || method != null) {
              logs[logDate] = [
                if (heartRate != null) "$heartRate",
                if (method != null) "$method",
              ];
            }
          } else if (tags == "pregnancyUSG") {
            String? fetalPosition = pregnancyLog.fetalPosition;
            String? placentaCondition = pregnancyLog.placentaCondition;
            int? fetalWeight = pregnancyLog.fetalWeight;
            if (fetalPosition != null || placentaCondition != null) {
              logs[logDate] = [
                if (fetalPosition != null) "$fetalPosition",
                if (placentaCondition != null) "$placentaCondition",
                if (fetalWeight != null) "$fetalWeight",
              ];
            }
          } else {
            if (tags == "temperature") {
              if (tagValue != null && double.tryParse(tagValue) != null && double.parse(tagValue) > 1) {
                logs[logDate] = [tagValue.toString()];
              }
            } else {
              if (tagValue != null && tagValue.toString().isNotEmpty) {
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

      var translatedLogs = sortedLogs.map((key, value) {
        String translatedSymptoms = value.map((symptom) => getTranslationKey(context, symptom)).join(', ');
        return MapEntry(key, translatedSymptoms);
      });
      var translatedPercentage30Days = percentage30Days.map((key, value) => MapEntry(getTranslationKey(context, key), value));
      var translatedPercentage3Months = percentage3Months.map((key, value) => MapEntry(getTranslationKey(context, key), value));
      var translatedPercentage6Months = percentage6Months.map((key, value) => MapEntry(getTranslationKey(context, key), value));
      var translatedPercentage1Year = percentage1Year.map((key, value) => MapEntry(getTranslationKey(context, key), value));

      return DailyLogTagsData(
        tags: tags,
        logs: translatedLogs,
        percentage30Days: translatedPercentage30Days,
        percentage3Months: translatedPercentage3Months,
        percentage6Months: translatedPercentage6Months,
        percentage1Year: translatedPercentage1Year,
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

  Future<PregnancyDailyLog?> addBloodPressure(BloodPressure bloodPressure) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      PregnancyDailyLog newPregnancyLog;

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
        newPregnancyLog = updatedPregnancyLog;
      } else {
        newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          tekananDarah: [bloodPressure],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }

      return newPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<PregnancyDailyLog?> editBloodPressure(BloodPressure bloodPressure) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];

      if (existingPregnancyLog == null) {
        _logger.e('Contraction data not found');
        return null;
      }

      int index = tekananDarah.indexWhere((element) => element.id == bloodPressure.id);
      if (index != -1) {
        tekananDarah[index] = bloodPressure;
        PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
          tekananDarah: tekananDarah,
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      }

      return existingPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<PregnancyDailyLog?> deleteBloodPressure(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BloodPressure>? tekananDarah = existingPregnancyLog?.tekananDarah ?? [];

      if (existingPregnancyLog == null) {
        _logger.e('Contraction data not found');
        return null;
      }

      tekananDarah.removeWhere((element) => element.id == id);
      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
        tekananDarah: tekananDarah,
        updatedAt: DateTime.now().toString(),
      );
      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);

      return updatedPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
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

  Future<PregnancyDailyLog?> addContractionTimer(String id, String waktuMulai, int durasi) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      PregnancyDailyLog newPregnancyLog;

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
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
        newPregnancyLog = updatedPregnancyLog;
      } else {
        newPregnancyLog = PregnancyDailyLog(
          userId: userId,
          riwayatKehamilanId: currentPregnancyData.id!,
          timerKontraksi: [latestContractionData],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _pregnancyLogRepository.upsertPregnancyDailyLog(newPregnancyLog);
      }

      return newPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
    }
  }

  Future<PregnancyDailyLog?> deleteContractionTimer(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
      }

      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<ContractionTimer>? timerKontraksi = existingPregnancyLog?.timerKontraksi ?? [];

      if (existingPregnancyLog == null) {
        _logger.e('Contraction data not found');
        return null;
      }

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

      timerKontraksi.removeWhere((element) => element.id == id);
      PregnancyDailyLog updatedPregnancyLog = existingPregnancyLog.copyWith(
        timerKontraksi: timerKontraksi,
        updatedAt: DateTime.now().toString(),
      );
      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);
      return updatedPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
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

  Future<PregnancyDailyLog?> addKicksCounter(String id, String datetime) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      PregnancyDailyLog updatedPregnancyLog;

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        return null;
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

      updatedPregnancyLog = existingPregnancyLog?.copyWith(
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

      return updatedPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
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

  Future<PregnancyDailyLog?> deleteKicksCounter(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      PregnancyHistory? currentPregnancyData = await _pregnancyHistoryRepository.getCurrentPregnancyHistory(userId);
      PregnancyDailyLog updatedPregnancyLog;

      if (currentPregnancyData == null) {
        _logger.e('Current pregnancy data is null');
        throw Exception("Current pregnancy data is null");
      }
      PregnancyDailyLog? existingPregnancyLog = await _pregnancyLogRepository.getPregnancyDailyLog(userId, currentPregnancyData.id!);
      List<BabyKicks>? gerakanBayi = existingPregnancyLog?.gerakanBayi ?? [];

      if (existingPregnancyLog == null) {
        _logger.e('Contraction data not found');
        return null;
      }

      gerakanBayi.removeWhere((element) => element.id == id);
      updatedPregnancyLog = existingPregnancyLog.copyWith(
        gerakanBayi: gerakanBayi,
        updatedAt: DateTime.now().toString(),
      );
      await _pregnancyLogRepository.upsertPregnancyDailyLog(updatedPregnancyLog);

      return updatedPregnancyLog;
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
      rethrow;
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

  String getTranslationKey(BuildContext context, String key) {
    final translations = getTranslations(context);
    return translations[key] ?? key;
  }

  Map<String, String> getTranslations(BuildContext context) {
    return {
      "Altered Body Image": AppLocalizations.of(context)!.alteredBodyImage,
      "Anxiety": AppLocalizations.of(context)!.anxiety,
      "Back Pain": AppLocalizations.of(context)!.backPain,
      "Breast Pain": AppLocalizations.of(context)!.breastPain,
      "Brownish Marks on Face": AppLocalizations.of(context)!.brownishMarksOnFace,
      "Carpal Tunnel": AppLocalizations.of(context)!.carpalTunnel,
      "Changes in Libido": AppLocalizations.of(context)!.changesInLibido,
      "Changes in Nipples": AppLocalizations.of(context)!.changesInNipples,
      "Constipation": AppLocalizations.of(context)!.constipation,
      "Dizziness": AppLocalizations.of(context)!.dizziness,
      "Dry Mouth": AppLocalizations.of(context)!.dryMouth,
      "Fainting": AppLocalizations.of(context)!.fainting,
      "Feeling Depressed": AppLocalizations.of(context)!.feelingDepressed,
      "Food Cravings": AppLocalizations.of(context)!.foodCravings,
      "Forgetfulness": AppLocalizations.of(context)!.forgetfulness,
      "Greasy Skin/Acne": AppLocalizations.of(context)!.greasySkinAcne,
      "Haemorrhoids": AppLocalizations.of(context)!.haemorrhoids,
      "Headache": AppLocalizations.of(context)!.headache,
      "Heart Palpitations": AppLocalizations.of(context)!.heartPalpitations,
      "Hip/Pelvic Pain": AppLocalizations.of(context)!.hipPelvicPain,
      "Increased Vaginal Discharge": AppLocalizations.of(context)!.increasedVaginalDischarge,
      "Incontinence/Leaking Urine": AppLocalizations.of(context)!.incontinenceLeakingUrine,
      "Itchy Skin": AppLocalizations.of(context)!.itchySkin,
      "Leg Cramps": AppLocalizations.of(context)!.legCramps,
      "Nausea": AppLocalizations.of(context)!.nausea,
      "Painful Vaginal Veins": AppLocalizations.of(context)!.painfulVaginalVeins,
      "Poor Sleep": AppLocalizations.of(context)!.poorSleep,
      "Reflux": AppLocalizations.of(context)!.reflux,
      "Restless Legs": AppLocalizations.of(context)!.restlessLegs,
      "Shortness of Breath": AppLocalizations.of(context)!.shortnessOfBreath,
      "Sciatica": AppLocalizations.of(context)!.sciatica,
      "Snoring": AppLocalizations.of(context)!.snoring,
      "Sore Nipples": AppLocalizations.of(context)!.soreNipples,
      "Stretch Marks": AppLocalizations.of(context)!.stretchMarks,
      "Swollen Hands/Feet": AppLocalizations.of(context)!.swollenHandsFeet,
      "Taste/Smell Changes": AppLocalizations.of(context)!.tasteSmellChanges,
      "Thrush": AppLocalizations.of(context)!.thrush,
      "Tiredness/Fatigue": AppLocalizations.of(context)!.tirednessFatigue,
      "Urinary Frequency": AppLocalizations.of(context)!.urinaryFrequency,
      "Varicose Veins": AppLocalizations.of(context)!.varicoseVeins,
      "Vivid Dreams": AppLocalizations.of(context)!.vividDreams,
      "Vomiting": AppLocalizations.of(context)!.vomiting,
    };
  }

  PregnancySymptoms _defaultPregnancySymptoms() {
    return PregnancySymptoms(
      alteredBodyImage: false,
      anxiety: false,
      backPain: false,
      breastPain: false,
      brownishMarksOnFace: false,
      carpalTunnel: false,
      changesInLibido: false,
      changesInNipples: false,
      constipation: false,
      dizziness: false,
      dryMouth: false,
      fainting: false,
      feelingDepressed: false,
      foodCravings: false,
      forgetfulness: false,
      greasySkinAcne: false,
      haemorrhoids: false,
      headache: false,
      heartPalpitations: false,
      hipPelvicPain: false,
      increasedVaginalDischarge: false,
      incontinenceLeakingUrine: false,
      itchySkin: false,
      legCramps: false,
      nausea: false,
      painfulVaginalVeins: false,
      poorSleep: false,
      reflux: false,
      restlessLegs: false,
      shortnessOfBreath: false,
      sciatica: false,
      snoring: false,
      soreNipples: false,
      stretchMarks: false,
      swollenHandsFeet: false,
      tasteSmellChanges: false,
      thrush: false,
      tirednessFatigue: false,
      urinaryFrequency: false,
      varicoseVeins: false,
      vividDreams: false,
      vomiting: false,
    );
  }
}
