import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';
import 'package:periodnpregnancycalender/app/services/services.dart';
import 'package:periodnpregnancycalender/app/repositories/repositories.dart';
import 'package:periodnpregnancycalender/app/models/models.dart';

class LogService {
  final Logger _logger = Logger();

  final StorageService storageService = StorageService();

  final LocalNotificationService _localNotificationService = LocalNotificationService();
  late final LocalLogRepository _localLogRepository = LocalLogRepository();

  Future<void> upsertDailyLog(String date, String? sexActivity, String? bleedingFlow, Map<String, bool>? symptoms, String? vaginalDischarge, Map<String, bool>? moods, Map<String, bool>? others, Map<String, bool>? physicalActivity, String? temperature, String? weight, String? notes) async {
    try {
      int userId = storageService.getAccountLocalId();
      DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

      DataHarian dailyLogByDate = DataHarian(
        date: date,
        sexActivity: sexActivity,
        bleedingFlow: bleedingFlow,
        symptoms: Symptoms.fromJson(symptoms ?? {}),
        vaginalDischarge: vaginalDischarge,
        moods: Moods.fromJson(moods ?? {}),
        others: Others.fromJson(others ?? {}),
        physicalActivity: PhysicalActivity.fromJson(physicalActivity ?? {}),
        temperature: temperature.toString(),
        weight: weight.toString(),
        notes: notes,
      );

      List<DataHarian> newDataHarian = [dailyLogByDate];

      if (existingLog != null) {
        List<DataHarian> existingDataHarian = existingLog.dataHarian ?? [];

        bool found = false;

        for (var i = 0; i < existingDataHarian.length; i++) {
          DateTime parsedExistingDate = DateTime.parse(existingDataHarian[i].date ?? "${DateTime.now()}");
          String formattedExistingDate = formatDate(parsedExistingDate);
          DateTime parsedDate = DateTime.parse(date);
          String formattedDate = formatDate(parsedDate);

          if (formattedExistingDate == formattedDate) {
            existingDataHarian[i] = dailyLogByDate;
            found = true;
            break;
          }
        }

        if (!found) {
          existingDataHarian.add(dailyLogByDate);
        }

        DailyLog updatedLog = existingLog.copyWith(
          dataHarian: existingDataHarian,
          updatedAt: DateTime.now().toString(),
        );
        await _localLogRepository.upsertDailyLog(updatedLog);
      } else {
        DailyLog newLog = DailyLog(
          userId: userId,
          dataHarian: newDataHarian,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _localLogRepository.upsertDailyLog(newLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteDailyLog(String date) async {
    int userId = storageService.getAccountLocalId();
    DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);
    try {
      if (existingLog != null) {
        List<DataHarian> existingDataHarian = existingLog.dataHarian ?? [];

        List<DataHarian> updatedDataHarian = existingDataHarian.where((data) {
          DateTime parsedExistingDate = DateTime.parse(data.date ?? "${DateTime.now()}");
          String formattedExistingDate = formatDate(parsedExistingDate);
          DateTime parsedDate = DateTime.parse(date);
          String formattedDate = formatDate(parsedDate);

          return formattedExistingDate != formattedDate;
        }).toList();

        DailyLog updatedLog = existingLog.copyWith(
          dataHarian: updatedDataHarian,
          updatedAt: DateTime.now().toString(),
        );

        await _localLogRepository.upsertDailyLog(updatedLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<DataHarian?> getLogsByDate(DateTime logDate) async {
    int userId = storageService.getAccountLocalId();
    final DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);

    String formatDates = formatDate(logDate);

    if (dailyLog != null && dailyLog.dataHarian != null) {
      final List<DataHarian> dataHarian = dailyLog.dataHarian!;

      try {
        DataHarian logByDate = dataHarian.firstWhere(
          (log) => log.date != null && DateTime.parse(log.date!).isAtSameMomentAs(DateTime.parse(formatDates)),
        );
        return logByDate;
      } catch (e) {
        return DataHarian(
          date: formatDates,
          moods: Moods(
            sad: false,
            calm: false,
            angry: false,
            happy: false,
            tired: false,
            cranky: false,
            frisky: false,
            sleepy: false,
            anxious: false,
            excited: false,
            confused: false,
            apathetic: false,
            depressed: false,
            emotional: false,
            energetic: false,
            irritated: false,
            sensitive: false,
            unfocused: false,
            frustrated: false,
            lowEnergy: false,
            moodSwings: false,
            feelingGuilty: false,
            obsessiveThoughts: false,
            verySelfCritical: false,
          ),
          symptoms: Symptoms(
            gas: false,
            pMS: false,
            acne: false,
            chills: false,
            cramps: false,
            nausea: false,
            fatigue: false,
            backache: false,
            bloating: false,
            cravings: false,
            diarrhea: false,
            headache: false,
            insomnia: false,
            spotting: false,
            swelling: false,
            dizziness: false,
            feelGood: false,
            bodyAches: false,
            hotFlashes: false,
            constipation: false,
            lowBackPain: false,
            nippleChanges: false,
            tenderBreasts: false,
            abdominalCramps: false,
          ),
          others: Others(
            stress: false,
            travel: false,
            alcohol: false,
            diseaseOrInjury: false,
          ),
          physicalActivity: PhysicalActivity(
            gym: false,
            yoga: false,
            cycling: false,
            running: false,
            walking: false,
            swimming: false,
            teamSports: false,
            didnTExercise: false,
            aerobicsDancing: false,
          ),
          notes: null,
          weight: null,
          sexActivity: null,
          temperature: null,
          vaginalDischarge: null,
          bleedingFlow: null,
        );
      }
    }

    return DataHarian();
  }

  Future<DailyLogTagsData> getLogsByTags(BuildContext context, String tags) async {
    List<String> allowedTags = [
      "sex_activity",
      "bleeding_flow",
      "symptoms",
      "vaginal_discharge",
      "moods",
      "others",
      "physical_activity",
      "temperature",
      "weight",
      "notes",
    ];
    if (!allowedTags.contains(tags)) {
      throw Exception("Invalid tags parameter.");
    }

    int userId = storageService.getAccountLocalId();
    final DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);
    final List<DataHarian>? dataHarian = dailyLog?.dataHarian;

    if (dataHarian == null || dataHarian.isEmpty) {
      return DailyLogTagsData(
        tags: tags,
        logs: {},
        percentage30Days: {},
        percentage3Months: {},
        percentage6Months: {},
        percentage1Year: {},
      );
    }

    Map<String, List<String>> logs = {};

    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
    DateTime threeMonthsAgo = now.subtract(Duration(days: 90));
    DateTime sixMonthsAgo = now.subtract(Duration(days: 180));
    DateTime oneYearAgo = now.subtract(Duration(days: 365));

    dataHarian.forEach((log) {
      String? logDate = log.date;
      if (logDate != null) {
        dynamic tagValue = log.toJson()[tags];

        if (tags == "symptoms" || tags == "moods" || tags == "others" || tags == "physical_activity") {
          Map<String, dynamic>? tagMap = log.toJson()[tags];
          if (tagMap != null && tagMap.isNotEmpty) {
            List<String> trueTags = tagMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
            if (trueTags.isNotEmpty) {
              logs[logDate] = trueTags;
            }
          }
        } else {
          if (tagValue != null && tagValue.toString().isNotEmpty) {
            if (tags == "temperature" || tags == "weight") {
              if (tagValue != null && double.parse(tagValue) > 1) {
                logs[logDate] = [tagValue.toString()];
              }
            } else {
              logs[logDate] = [tagValue.toString()];
            }
          }
        }
      }
    });

    var sortedLogs = Map.fromEntries(logs.entries.toList()..sort((a, b) => DateTime.parse(b.key).compareTo(DateTime.parse(a.key))));

    logs.removeWhere((key, value) => value.isEmpty);

    Map<String, int> percentage30Days = findOccurrences(logs, thirtyDaysAgo);
    Map<String, int> percentage3Months = findOccurrences(logs, threeMonthsAgo);
    Map<String, int> percentage6Months = findOccurrences(logs, sixMonthsAgo);
    Map<String, int> percentage1Year = findOccurrences(logs, oneYearAgo);

    var translatedLogs = sortedLogs.map((key, value) {
      String translatedValue = value.map((symptom) => getTranslationKey(context, symptom)).join(', ');
      return MapEntry(key, translatedValue);
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

  Future<List<Reminders>?> getAllReminder() async {
    int userId = storageService.getAccountLocalId();
    final DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);
    return await dailyLog?.pengingat;
  }

  Future<void> addReminder(Reminders reminder) async {
    try {
      int userId = storageService.getAccountLocalId();
      DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

      _localNotificationService.scheduleReminder(reminder);

      if (existingLog != null) {
        List<Reminders> existingReminders = existingLog.pengingat ?? [];

        existingReminders.add(reminder);

        DailyLog updatedLog = existingLog.copyWith(
          pengingat: existingReminders,
          updatedAt: DateTime.now().toString(),
        );
        await _localLogRepository.upsertDailyLog(updatedLog);
      } else {
        DailyLog newLog = DailyLog(
          userId: userId,
          pengingat: [reminder],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString(),
        );
        await _localLogRepository.upsertDailyLog(newLog);
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> editReminder(Reminders reminder) async {
    try {
      int userId = storageService.getAccountLocalId();
      DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

      _localNotificationService.editReminder(reminder);

      if (existingLog != null) {
        List<Reminders> existingReminders = existingLog.pengingat ?? [];

        int index = existingReminders.indexWhere((r) => r.id == reminder.id);

        if (index != -1) {
          existingReminders[index] = reminder;

          DailyLog updatedLog = existingLog.copyWith(
            pengingat: existingReminders,
            updatedAt: DateTime.now().toString(),
          );

          await _localLogRepository.upsertDailyLog(updatedLog);
        } else {
          throw Exception('Reminder with ID ${reminder.id} not found');
        }
      } else {
        throw Exception('No reminder found for user with ID $userId');
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteAllReminder() async {
    try {
      int userId = storageService.getAccountLocalId();
      DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

      if (existingLog != null) {
        DailyLog updatedLog = existingLog.copyWith(
          pengingat: [],
          updatedAt: DateTime.now().toString(),
        );

        await _localLogRepository.upsertDailyLog(updatedLog);
      } else {
        throw Exception('No reminder found for user with ID $userId');
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      int userId = storageService.getAccountLocalId();
      DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

      _localNotificationService.cancelReminder(id);

      if (existingLog != null) {
        List<Reminders> existingReminders = existingLog.pengingat ?? [];

        int index = existingReminders.indexWhere((r) => r.id == id);

        if (index != -1) {
          existingReminders.removeAt(index);

          DailyLog updatedLog = existingLog.copyWith(
            pengingat: existingReminders,
            updatedAt: DateTime.now().toString(),
          );

          await _localLogRepository.upsertDailyLog(updatedLog);
        } else {
          throw Exception('Reminder with ID ${id} not found');
        }
      } else {
        throw Exception('No log found for user with ID $userId');
      }
    } catch (e) {
      _logger.e('[LOCAL ERROR] $e');
    }
  }

  String getTranslationKey(BuildContext context, String key) {
    final translations = getTranslations(context);
    return translations[key] ?? key;
  }

  Map<String, String> getTranslations(BuildContext context) {
    return {
      "Didn't have sex": AppLocalizations.of(context)!.didntHaveSex,
      "Unprotected sex": AppLocalizations.of(context)!.unprotectedSex,
      "Protected sex": AppLocalizations.of(context)!.protectedSex,
      "No discharge": AppLocalizations.of(context)!.noDischarge,
      "Creamy": AppLocalizations.of(context)!.creamyDischarge,
      "Spotting": AppLocalizations.of(context)!.spottingDischarge,
      "Eggwhite": AppLocalizations.of(context)!.eggwhiteDischarge,
      "Sticky": AppLocalizations.of(context)!.stickyDischarge,
      "Watery": AppLocalizations.of(context)!.wateryDischarge,
      "Unusual": AppLocalizations.of(context)!.unusualDischarge,
      "Light": AppLocalizations.of(context)!.lightBleedingFlow,
      "Medium": AppLocalizations.of(context)!.mediumBleedingFlow,
      "Heavy": AppLocalizations.of(context)!.heavyBleedingFlow,
      "Abdominal cramps": AppLocalizations.of(context)!.abdominalCramps,
      "Acne": AppLocalizations.of(context)!.acne,
      "Backache": AppLocalizations.of(context)!.backache,
      "Bloating": AppLocalizations.of(context)!.bloating,
      "Body aches": AppLocalizations.of(context)!.bodyAches,
      "Chills": AppLocalizations.of(context)!.chills,
      "Constipation": AppLocalizations.of(context)!.constipation,
      "Cramps": AppLocalizations.of(context)!.cramps,
      "Cravings": AppLocalizations.of(context)!.cravings,
      "Diarrhea": AppLocalizations.of(context)!.diarrhea,
      "Dizziness": AppLocalizations.of(context)!.dizziness,
      "Fatigue": AppLocalizations.of(context)!.fatigue,
      "Feel good": AppLocalizations.of(context)!.feelGood,
      "Gas": AppLocalizations.of(context)!.gas,
      "Headache": AppLocalizations.of(context)!.headache,
      "Hot flashes": AppLocalizations.of(context)!.hotFlashes,
      "Insomnia": AppLocalizations.of(context)!.insomnia,
      "Low back pain": AppLocalizations.of(context)!.lowBackPain,
      "Nausea": AppLocalizations.of(context)!.nausea,
      "Nipple changes": AppLocalizations.of(context)!.nippleChanges,
      "PMS": AppLocalizations.of(context)!.pms,
      "Swelling": AppLocalizations.of(context)!.swelling,
      "Tender breasts": AppLocalizations.of(context)!.tenderBreasts,
      "Angry": AppLocalizations.of(context)!.angry,
      "Anxious": AppLocalizations.of(context)!.anxious,
      "Apathetic": AppLocalizations.of(context)!.apathetic,
      "Calm": AppLocalizations.of(context)!.calm,
      "Confused": AppLocalizations.of(context)!.confused,
      "Cranky": AppLocalizations.of(context)!.cranky,
      "Depressed": AppLocalizations.of(context)!.depressed,
      "Emotional": AppLocalizations.of(context)!.emotional,
      "Energetic": AppLocalizations.of(context)!.energetic,
      "Excited": AppLocalizations.of(context)!.excited,
      "Feeling guilty": AppLocalizations.of(context)!.feelingGuilty,
      "Frisky": AppLocalizations.of(context)!.frisky,
      "Frustrated": AppLocalizations.of(context)!.frustrated,
      "Happy": AppLocalizations.of(context)!.happy,
      "Irritated": AppLocalizations.of(context)!.irritated,
      "Low energy": AppLocalizations.of(context)!.lowEnergy,
      "Mood swings": AppLocalizations.of(context)!.moodSwings,
      "Obsessive thoughts": AppLocalizations.of(context)!.obsessiveThoughts,
      "Sad": AppLocalizations.of(context)!.sad,
      "Sensitive": AppLocalizations.of(context)!.sensitive,
      "Sleepy": AppLocalizations.of(context)!.sleepy,
      "Tired": AppLocalizations.of(context)!.tired,
      "Unfocused": AppLocalizations.of(context)!.unfocused,
      "Very self-critical": AppLocalizations.of(context)!.verySelfCritical,
      "Travel": AppLocalizations.of(context)!.travel,
      "Stress": AppLocalizations.of(context)!.stress,
      "Disease or Injury": AppLocalizations.of(context)!.diseaseOrInjury,
      "Alcohol": AppLocalizations.of(context)!.alcohol,
      "Didn't exercise": AppLocalizations.of(context)!.didntExercise,
      "Yoga": AppLocalizations.of(context)!.yoga,
      "Gym": AppLocalizations.of(context)!.gym,
      "Aerobics & Dancing": AppLocalizations.of(context)!.aerobicsAndDancing,
      "Swimming": AppLocalizations.of(context)!.swimming,
      "Team sports": AppLocalizations.of(context)!.teamSports,
      "Running": AppLocalizations.of(context)!.running,
      "Cycling": AppLocalizations.of(context)!.cycling,
      "Walking": AppLocalizations.of(context)!.walking,
    };
  }
}
