import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/repositories/log_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderController extends GetxController {
  final ApiService apiService = ApiService();
  late final LogRepository logRepository = LogRepository(apiService);
  RxList<Reminders> reminders = <Reminders>[].obs;
  Rx<DateTime?> dateSelected = Rx<DateTime?>(DateTime.now());
  Rx<TimeOfDay?> timeSelected = Rx<TimeOfDay?>(null);
  RxString reminderTitle = RxString("");
  RxString reminderDescription = RxString("");
  late Future<void> reminderFuture;

  @override
  void onInit() {
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
    try {
      Reminder? result = await logRepository.getAllReminder();

      if (result != null && result.data != null) {
        reminders.assignAll(result.data!);
      } else {
        print("Error: Unable to fetch articles");
      }

      update();
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  Future<void> storeReminder() async {
    try {
      String? selectedDate = formattedSelectedDate;

      if (selectedDate == null || selectedDate.isEmpty) {
        selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }

      await logRepository.storeReminder(getReminderTitle(),
          getReminderDescription(), '$selectedDate $formattedSelectedTime');
      cancelEdit();
      fetchAllReminder();
    } catch (e) {
      print("Error fetching reminders: $e");
    }
  }

  Future<void> editReminder(String id, String originalTitle,
      String? originalDescription, String? originalDateTime) async {
    try {
      String? editedTitle = getReminderTitle();
      String? editedDescription = getReminderDescription();
      String? editedSelectedDate = formattedSelectedDate;
      String? editedSelectedTime = formattedSelectedTime;

      if (editedTitle.isEmpty) {
        editedTitle = originalTitle;
      }

      if (editedDescription.isEmpty) {
        editedDescription = originalDescription;
      }

      if (editedSelectedDate == null || editedSelectedDate.isEmpty) {
        editedSelectedDate = originalDateTime != null
            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(originalDateTime))
            : null;
      }

      if (editedSelectedTime == null || editedSelectedTime.isEmpty) {
        editedSelectedTime = originalDateTime != null
            ? DateFormat('HH:mm').format(DateTime.parse(originalDateTime))
            : null;
      }

      String? editedDateTime =
          editedSelectedDate != null && editedSelectedTime != null
              ? '$editedSelectedDate $editedSelectedTime'
              : null;

      if (editedDateTime != null) {
        await logRepository.editReminder(
          id,
          editedTitle,
          editedDescription,
          editedDateTime,
        );
        fetchAllReminder();
        cancelEdit();
      }
    } catch (e) {
      print("Error fetching reminders: $e");
    }
  }

  Future<void> deleteReminder(String id) async {
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
