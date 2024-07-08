import 'package:periodnpregnancycalender/app/models/daily_log_date_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_model.dart';
import 'package:periodnpregnancycalender/app/models/daily_log_tags_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class LogService {
  final LocalLogRepository _localLogRepository;
  final StorageService storageService = StorageService();

  LogService(this._localLogRepository);

  Future<void> upsertDailyLog(String date, String? sexActivity, String? bleedingFlow, Map<String, bool>? symptoms, String? vaginalDischarge, Map<String, bool>? moods, Map<String, bool>? others, Map<String, bool>? physicalActivity, String? temperature, String? weight, String? notes) async {
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
      temperature: temperature,
      weight: weight,
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
  }

  Future<DataHarian?> getLogsByDate(DateTime logDate) async {
    int userId = storageService.getAccountLocalId();
    final DailyLog? dailyLog = await _localLogRepository.getDailyLog(userId);

    if (dailyLog != null && dailyLog.dataHarian != null) {
      final List<DataHarian> dataHarian = dailyLog.dataHarian!;

      try {
        DataHarian logByDate = dataHarian.firstWhere(
          (log) => log.date != null && DateTime.parse(log.date!).isAtSameMomentAs(logDate),
        );
        return logByDate;
      } catch (e) {
        return DataHarian();
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
        if (tags == "symptoms" || tags == "moods" || tags == "others" || tags == "physical_activity") {
          Map<String, dynamic> tagMap = log.toJson()[tags];
          if (tagMap != null && tagMap.isNotEmpty) {
            List<String> trueTags = tagMap.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
            if (trueTags.isNotEmpty) {
              logs[logDate] = trueTags;
            }
          }
        } else {
          dynamic tagValue = log.toJson()[tags];
          if (tagValue != null && tagValue.toString().isNotEmpty) {
            logs[logDate] = [tagValue.toString()];
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
    int userId = storageService.getAccountLocalId();
    var uuid = Uuid();
    DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

    reminder.id = uuid.v4();

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
  }

  Future<void> editReminder(Reminders reminder) async {
    int userId = storageService.getAccountLocalId();
    DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

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
      throw Exception('No log found for user with ID $userId');
    }
  }

  Future<void> deleteAllReminder() async {
    int userId = storageService.getAccountLocalId();
    DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);
    print(existingLog?.pengingat.toString());

    if (existingLog != null) {
      DailyLog updatedLog = existingLog.copyWith(
        pengingat: [],
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _localLogRepository.upsertDailyLog(updatedLog);
    } else {
      throw Exception('No log found for user with ID $userId');
    }
  }

  Future<void> deleteReminder(String id) async {
    int userId = storageService.getAccountLocalId();
    DailyLog? existingLog = await _localLogRepository.getDailyLog(userId);

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
  }
}
