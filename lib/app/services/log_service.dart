import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:intl/intl.dart';

class LogService {
  final Logger _logger = Logger();
  final LocalLogRepository _localLogRepository;
  final StorageService storageService = StorageService();
  final LocalNotificationService _localNotificationService = LocalNotificationService();

  LogService(this._localLogRepository);

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
          String formattedExistingDate = DateFormat('yyyy-MM-dd').format(parsedExistingDate);
          DateTime parsedDate = DateTime.parse(date);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

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
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _localLogRepository.upsertDailyLog(updatedLog);
      } else {
        DailyLog newLog = DailyLog(
          userId: userId,
          dataHarian: newDataHarian,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
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
          String formattedExistingDate = DateFormat('yyyy-MM-dd').format(parsedExistingDate);
          DateTime parsedDate = DateTime.parse(date);
          String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

          return formattedExistingDate != formattedDate;
        }).toList();

        DailyLog updatedLog = existingLog.copyWith(
          dataHarian: updatedDataHarian,
          updatedAt: DateTime.now().toIso8601String(),
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

  Future<DailyLogTagsData> getLogsByTags(String tags) async {
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

    return DailyLogTagsData(
      tags: tags,
      logs: sortedLogs,
      percentage30Days: percentage30Days,
      percentage3Months: percentage3Months,
      percentage6Months: percentage6Months,
      percentage1Year: percentage1Year,
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
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _localLogRepository.upsertDailyLog(updatedLog);
      } else {
        DailyLog newLog = DailyLog(
          userId: userId,
          pengingat: [reminder],
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
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
            updatedAt: DateTime.now().toIso8601String(),
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
          updatedAt: DateTime.now().toIso8601String(),
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
            updatedAt: DateTime.now().toIso8601String(),
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
}
