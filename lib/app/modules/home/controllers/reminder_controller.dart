import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final LogRepository logRepository = LogRepository(apiService);
  late final LogService _logService;
  late final SyncDataRepository _syncDataRepository;

  RxList<Reminders> reminders = <Reminders>[].obs;
  Rx<DateTime?> dateSelected = Rx<DateTime?>(DateTime.now());
  Rx<TimeOfDay?> timeSelected = Rx<TimeOfDay?>(null);
  RxString reminderTitle = RxString("");
  RxString reminderDescription = RxString("");
  late Future<void> reminderFuture;

  @override
  void onInit() {
    final databaseHelper = DatabaseHelper.instance;
    final localLogRepository = LocalLogRepository(databaseHelper);
    _logService = LogService(localLogRepository);
    _syncDataRepository = SyncDataRepository(databaseHelper);

    reminderFuture = fetchAllReminder();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String? get formattedSelectedDate {
    final selectedDate = dateSelected.value;

    if (selectedDate != null) {
      return DateFormat('yyyy-MM-dd').format(selectedDate);
    }

    return null;
  }

  String? get formattedSelectedTime {
    final time = timeSelected.value;

    if (time != null) {
      return DateFormat('HH:mm').format(DateTime(
        0,
        0,
        0,
        time.hour,
        time.minute,
      ));
    }

    return null;
  }

  DateTime? getDate() => dateSelected.value;
  void setDate(DateTime? date) {
    dateSelected.value = date;
  }

  void setTime(TimeOfDay? time) {
    timeSelected.value = time;
    print(timeSelected);
  }

  String getReminderTitle() => reminderTitle.value;
  void updateReminderTitle(String text) {
    reminderTitle.value = text;
    update();
  }

  String getReminderDescription() => reminderDescription.value;
  void updateReminderDescription(String text) {
    reminderDescription.value = text;
    update();
  }

  String formatDateTime(String? datetime) {
    DateTime? reminderDate = datetime != null ? DateTime.parse(datetime) : null;
    DateTime currentDate = DateTime.now();
    DateTime tomorrowDate = DateTime.now().add(Duration(days: 1));

    if (reminderDate != null) {
      if (isSameDay(reminderDate, currentDate)) {
        return 'Today';
      } else if (isSameDay(reminderDate, tomorrowDate)) {
        return 'Tomorrow';
      } else {
        return DateFormat('EEEE, dd MMMM yyyy').format(reminderDate);
      }
    } else {
      return '';
    }
  }

  // Future<void> fetchAllReminder() async {
  //   try {
  //     Reminder? result = await logRepository.getAllReminder();

  //     if (result != null && result.data != null) {
  //       reminders.assignAll(result.data!);
  //     } else {
  //       print("Error: Unable to fetch articles");
  //     }

  //     update();
  //   } catch (e) {
  //     print("Error fetching articles: $e");
  //   }
  // }

  Future<void> fetchAllReminder() async {
    try {
      List<Reminders>? result = await _logService.getAllReminder();

      if (result != null) {
        reminders.assignAll(result);
      } else {
        print("Error: Unable to fetch articles");
      }

      update();
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  Future<void> storeReminder() async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    String? selectedDate = formattedSelectedDate;

    if (selectedDate == null || selectedDate.isEmpty) {
      selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    Reminders newReminder = Reminders(
      title: getReminderTitle(),
      description: getReminderDescription(),
      datetime: '$selectedDate $formattedSelectedTime',
    );

    if (storageService.getIsAuth() && !isConnected) {
      await _logService.addReminder(newReminder);
      saveSyncLog(selectedDate);
      return;
    }

    try {
      var reminderAdded = await logRepository.storeReminder(getReminderTitle(), getReminderDescription(), '$selectedDate $formattedSelectedTime');
      Reminders newReminders = Reminders(
        remoteId: reminderAdded["data"]["id"],
        title: getReminderTitle(),
        description: getReminderDescription(),
        datetime: '$selectedDate $formattedSelectedTime',
      );

      await _logService.addReminder(newReminders);
      cancelEdit();
      fetchAllReminder();
    } catch (e) {
      saveSyncLog(selectedDate);
    }
  }

  Future<void> saveSyncLog(String selectedDate) async {
    Map<String, dynamic> data = {
      'title': getReminderTitle(),
      'description': getReminderDescription(),
      'datetime': '$selectedDate $formattedSelectedTime',
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian',
      operation: 'addReminder',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> editReminder(String id, String remoteId, String originalTitle, String? originalDescription, String? originalDateTime) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    String editedTitle = getReminderTitle().isEmpty ? originalTitle : getReminderTitle();
    String? editedDescription = getReminderDescription().isEmpty ? originalDescription : getReminderDescription();
    String? editedSelectedDate = formattedSelectedDate?.isEmpty ?? true ? null : formattedSelectedDate;
    String? editedSelectedTime = formattedSelectedTime?.isEmpty ?? true ? null : formattedSelectedTime;

    editedSelectedDate ??= originalDateTime != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(originalDateTime)) : null;
    editedSelectedTime ??= originalDateTime != null ? DateFormat('HH:mm').format(DateTime.parse(originalDateTime)) : null;

    String? editedDateTime = (editedSelectedDate != null && editedSelectedTime != null) ? '$editedSelectedDate $editedSelectedTime' : null;

    Reminders editReminder = Reminders(
      id: id,
      remoteId: remoteId,
      title: editedTitle,
      description: editedDescription,
      datetime: editedDateTime,
    );

    await _logService.editReminder(editReminder);

    if (storageService.getIsAuth() && !isConnected) {
      Map<String, dynamic> data = {
        'title': editedTitle,
        'description': editedDescription,
        'datetime': editedDateTime,
      };

      String jsonData = jsonEncode(data);

      SyncLog syncLog = SyncLog(
        tableName: 'tb_data_harian',
        operation: 'addReminder',
        data: jsonData,
        createdAt: DateTime.now().toString(),
      );

      await _syncDataRepository.addSyncLogData(syncLog);
      return;
    }

    try {
      print(remoteId);
      await logRepository.editReminder(
        remoteId,
        editedTitle,
        editedDescription,
        editedDateTime ?? "${DateTime.now()}",
      );
      await _logService.editReminder(editReminder);
      fetchAllReminder();
      cancelEdit();
    } catch (e) {
      print("Error fetching reminders: $e");
      Map<String, dynamic> data = {
        'title': editedTitle,
        'description': editedDescription,
        'datetime': editedDateTime,
      };

      String jsonData = jsonEncode(data);

      SyncLog syncLog = SyncLog(
        tableName: 'tb_data_harian',
        operation: 'addReminder',
        data: jsonData,
        createdAt: DateTime.now().toString(),
      );

      await _syncDataRepository.addSyncLogData(syncLog);
    }
  }

  Future<void> deleteReminder(String id, String remoteId) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    await _logService.deleteReminder(id);

    if (storageService.getIsAuth() && !isConnected) {
      Map<String, dynamic> data = {
        'id': remoteId,
      };

      String jsonData = jsonEncode(data);

      SyncLog syncLog = SyncLog(
        tableName: 'tb_data_harian',
        operation: 'addReminder',
        data: jsonData,
        createdAt: DateTime.now().toString(),
      );

      await _syncDataRepository.addSyncLogData(syncLog);
      return;
    }

    try {
      await logRepository.deleteReminder(remoteId);
      fetchAllReminder();
      update();
    } catch (e) {
      print("Error fetching reminders: $e");
      Map<String, dynamic> data = {
        'id': remoteId,
      };

      String jsonData = jsonEncode(data);

      SyncLog syncLog = SyncLog(
        tableName: 'tb_data_harian',
        operation: 'addReminder',
        data: jsonData,
        createdAt: DateTime.now().toString(),
      );

      await _syncDataRepository.addSyncLogData(syncLog);
    }

    await logRepository.deleteReminder(id);
    fetchAllReminder();
    update();
  }

  void cancelEdit() {
    reminderTitle.value = "";
    reminderDescription.value = "";
    dateSelected.value = null;
    timeSelected.value = null;
  }
}
