import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/models/sync_log_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/log_repository.dart';
import 'package:periodnpregnancycalender/app/repositories/local/sync_data_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/services/log_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class ReminderController extends GetxController {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  late final LogRepository logRepository = LogRepository(apiService);
  late final LogService _logService;
  late final SyncDataRepository _syncDataRepository;
  final LocalNotificationService localNotificationService = LocalNotificationService();

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

  Future<void> fetchAllReminder() async {
    List<Reminders>? result = await _logService.getAllReminder();

    if (result != null) {
      reminders.assignAll(result);
      update();
    } else {
      print("Error: Unable to fetch reminders");
    }
  }

  void checkReminder(BuildContext context) {
    try {
      if (formattedSelectedDate == null || formattedSelectedDate!.isEmpty) {
        throw "Please select a date when the reminder will be triggered";
      }
      if (formattedSelectedTime == null || formattedSelectedTime!.isEmpty) {
        throw "Please select a time when the reminder will be triggered";
      }
      if (getReminderTitle().isEmpty) {
        throw "Please fill out the reminder title";
      }
      if (getReminderDescription().isEmpty) {
        throw "Please fill out the reminder description";
      }

      storeReminder(context);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> storeReminder(context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String? selectedDate = formattedSelectedDate;
    var uuid = Uuid();
    var id = uuid.v4();

    if (selectedDate != null && formattedSelectedTime != null) {
      Reminders newReminder = Reminders(
        id: id,
        title: getReminderTitle(),
        description: getReminderDescription(),
        datetime: '$selectedDate $formattedSelectedTime',
      );

      try {
        await _logService.addReminder(newReminder);
        Get.showSnackbar(Ui.SuccessSnackBar(message: 'Reminder added successfully!'));
        localSuccess = true;
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to add reminder. Please try again later!'));
      }

      await fetchAllReminder();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ReminderView()),
        (Route<dynamic> route) => route.isFirst,
      );

      if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
        try {
          await logRepository.storeReminder(id, getReminderTitle(), getReminderDescription(), '$selectedDate $formattedSelectedTime');
        } catch (e) {
          await saveAddSyncReminder(id, selectedDate);
        }
      } else if (localSuccess) {
        await saveAddSyncReminder(id, selectedDate);
      }

      cancelEdit();
    }
  }

  Future<void> saveAddSyncReminder(String id, String selectedDate) async {
    Map<String, dynamic> data = {
      'id': id,
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

  Future<void> editReminder(String id, String originalTitle, String? originalDescription, String? originalDateTime, context) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;
    String editedTitle = getReminderTitle().isEmpty ? originalTitle : getReminderTitle();
    String? editedDescription = getReminderDescription().isEmpty ? originalDescription : getReminderDescription();
    String? editedSelectedDate = formattedSelectedDate?.isEmpty ?? true ? null : formattedSelectedDate;
    String? editedSelectedTime = formattedSelectedTime?.isEmpty ?? true ? null : formattedSelectedTime;

    editedSelectedDate ??= originalDateTime != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(originalDateTime)) : null;
    editedSelectedTime ??= originalDateTime != null ? DateFormat('HH:mm').format(DateTime.parse(originalDateTime)) : null;

    String? editedDateTime = (editedSelectedDate != null && editedSelectedTime != null) ? '$editedSelectedDate $editedSelectedTime' : null;
    Reminders editReminder = Reminders(
      id: id,
      title: editedTitle,
      description: editedDescription,
      datetime: editedDateTime,
    );

    try {
      await _logService.editReminder(editReminder);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Reminder edited successfully!'));
      localSuccess = true;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to edit reminder. Please try again later!'));
    }

    await fetchAllReminder();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ReminderView()),
      (Route<dynamic> route) => route.isFirst,
    );

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await logRepository.editReminder(id, editedTitle, editedDescription, editedDateTime ?? "${DateTime.now()}");
      } catch (e) {
        await saveEditSyncReminder(id, editedTitle, editedDescription, editedDateTime);
      }
    } else if (localSuccess) {
      await saveEditSyncReminder(id, editedTitle, editedDescription, editedDateTime);
    }

    cancelEdit();
  }

  Future<void> saveEditSyncReminder(String id, String? editedTitle, String? editedDescription, String? editedDateTime) async {
    Map<String, dynamic> data = {
      'id': id,
      'title': editedTitle,
      'description': editedDescription,
      'datetime': editedDateTime,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian',
      operation: 'editReminder',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  Future<void> deleteReminder(String id) async {
    bool isConnected = await CheckConnectivity().isConnectedToInternet();
    bool localSuccess = false;

    try {
      await _logService.deleteReminder(id);
      localSuccess = true;
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'All reminder deleted successfully!'));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: 'Failed to delete all reminder. Please try again later!'));
    }

    await fetchAllReminder();
    update();

    if (isConnected && localSuccess && storageService.getCredentialToken() != null && storageService.getIsBackup()) {
      try {
        await logRepository.deleteReminder(id);
      } catch (e) {
        await deleteSyncReminder(id);
      }
    } else {
      await deleteSyncReminder(id);
    }
  }

  Future<void> deleteSyncReminder(String id) async {
    Map<String, dynamic> data = {
      'id': id,
    };

    String jsonData = jsonEncode(data);

    SyncLog syncLog = SyncLog(
      tableName: 'tb_data_harian',
      operation: 'deleteReminder',
      data: jsonData,
      createdAt: DateTime.now().toString(),
    );

    await _syncDataRepository.addSyncLogData(syncLog);
  }

  void cancelEdit() {
    reminderTitle.value = "";
    reminderDescription.value = "";
    dateSelected.value = null;
    timeSelected.value = null;
  }
}
