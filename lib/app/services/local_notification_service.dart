import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/models/reminder_model.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final StorageService storageService = StorageService();
  late tz.Location _local;

  Future<void> initTimezone() async {
    tz.initializeTimeZones();
    _local = tz.local;
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> createNotification(
    int id,
    String title,
    String description,
    String datetime,
    String channelId,
    String channelName,
    String channelDescription,
  ) async {
    await initTimezone();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      description,
      tz.TZDateTime.from(DateTime.parse(datetime), tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleReminder(Reminders reminder) async {
    createNotification(_hashUuid(reminder.id!), reminder.title!, reminder.description!, reminder.datetime!, "reminder_channel", "Reminders", "Notifications for reminders");
  }

  Future<void> cancelReminder(String id) async {
    int canceledId = _hashUuid(id);
    await flutterLocalNotificationsPlugin.cancel(canceledId);
  }

  Future<void> editReminder(Reminders reminder) async {
    await cancelReminder(reminder.id!);
    await scheduleReminder(reminder);
  }

  Future<void> schedulePeriodCycle(int id, String title, String description, String datetime) async {
    createNotification(id, title, description, datetime, "period_channel", "Period Notifications", "Notifications for period cycle");
  }

  Future<void> scheduleNotificationPeriod(PeriodHistory periodHistory) async {
    int userId = storageService.getAccountLocalId();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (userId != 0) {
      DateTime endPeriod = periodHistory.haidAkhir!;
      DateTime fertileStart = periodHistory.masaSuburAwal!;
      DateTime fertileEnd = periodHistory.masaSuburAkhir!;
      DateTime ovulation = periodHistory.ovulasi!;
      DateTime nextPeriod = periodHistory.haidBerikutnyaAwal!;

      cancelAllPeriodNotifications(userId);
      cancelAllPregnancyNotifications(userId);

      String idSuffix = "001";
      if (today.isBefore(endPeriod) || today.isAtSameMomentAs(endPeriod)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Period Ended', 'Has your period ended? Please update your menstrual cycle records.', endPeriod.add(Duration(days: 1)).toIso8601String());
      }

      idSuffix = "002";
      if (today.isBefore(fertileStart) || today.isAtSameMomentAs(fertileStart)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Fertility Window Start', 'Your fertility window starts today.', fertileStart.toIso8601String());
      }

      idSuffix = "003";
      if (today.isBefore(fertileEnd) || today.isAtSameMomentAs(fertileEnd)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Fertility Window End', 'Your fertility window ends today.', fertileEnd.toIso8601String());
      }

      idSuffix = "004";
      if (today.isBefore(ovulation) || today.isAtSameMomentAs(ovulation)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Ovulation Day', 'Today is your ovulation day.', ovulation.toIso8601String());
      }

      for (int i = 5; i > 0; i--) {
        idSuffix = "00${5 + 4 - i}";
        DateTime notificationDate = nextPeriod.subtract(Duration(days: i));
        if (today.isBefore(notificationDate) || today.isAtSameMomentAs(notificationDate)) {
          var id = "$userId$idSuffix";
          await schedulePeriodCycle(int.parse(id), 'Upcoming Menstrual Cycle', 'Your next menstrual cycle is expected to start in $i days.', notificationDate.toIso8601String());
        }
      }

      idSuffix = "010";
      DateTime remindDate = today.add(Duration(days: 3));
      if (today.isBefore(remindDate) || today.isAtSameMomentAs(remindDate)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Update Menstrual Cycle', 'Please record your latest menstrual cycle data.', remindDate.toIso8601String());
      }

      idSuffix = "011";
      DateTime checkPregnancyDate = periodHistory.haidAwal!.add(Duration(days: 60));
      if (today.isBefore(checkPregnancyDate) || today.isAtSameMomentAs(checkPregnancyDate)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Check Pregnancy', 'It has been 8 weeks since your last recorded period. Are you pregnant? Please update your records.', checkPregnancyDate.toIso8601String());
      }

      idSuffix = "012";
      DateTime longRemindDate = today.add(Duration(days: 30));
      if (today.isBefore(longRemindDate) || today.isAtSameMomentAs(longRemindDate)) {
        var id = "$userId$idSuffix";
        await schedulePeriodCycle(int.parse(id), 'Reminder to Record', 'It has been a while since you last updated your menstrual cycle. Please record your latest data.', longRemindDate.toIso8601String());
      }
    }
  }

  Future<void> cancelAllPeriodNotifications(int userId) async {
    for (int i = 1; i <= 12; i++) {
      String idSuffix = i.toString().padLeft(3, '0');
      int notificationId = int.parse("$userId$idSuffix");
      await flutterLocalNotificationsPlugin.cancel(notificationId);
    }
  }

  Future<void> schedulePregnancy(int id, String title, String description, String datetime) async {
    createNotification(id, title, description, datetime, "pregnancy_channel", "Pregnanyc Notifications", "Notifications for pregnancy");
  }

  Future<void> scheduleNotificationReminder(DateTime hariPertamaHaidTerakhir) async {
    int userId = storageService.getAccountLocalId();

    if (userId != 0) {
      cancelAllPregnancyNotifications(userId);
      cancelAllPeriodNotifications(userId);

      Duration differenceDays = DateTime.now().difference(hariPertamaHaidTerakhir);
      int weeksPregnant = (differenceDays.inDays / 7).ceil();

      for (int minggu = weeksPregnant; minggu <= 40; minggu++) {
        String idSuffix = minggu.toString().padLeft(3, '0');
        var id = "$userId$idSuffix";

        DateTime firstDayOfTheWeek = hariPertamaHaidTerakhir.add(Duration(days: (minggu - 1) * 7));

        await schedulePregnancy(int.parse(id + '1'), 'Pregnancy Started', 'Week $minggu, Click here to see your highlight, changes, and symptoms you might feel this week.', firstDayOfTheWeek.toIso8601String());
        await schedulePregnancy(int.parse(id + '2'), 'Weight Tracker', 'Fill out your weight this week. It helps track down the weight gain of both the baby and you.', firstDayOfTheWeek.add(Duration(days: 2)).toIso8601String());
      }
    }
  }

  Future<void> cancelAllPregnancyNotifications(int userId) async {
    for (int minggu = 1; minggu <= 40; minggu++) {
      String idSuffix = minggu.toString().padLeft(3, '0');
      int notificationId1 = int.parse("$userId${idSuffix}1");
      int notificationId2 = int.parse("$userId${idSuffix}2");
      await flutterLocalNotificationsPlugin.cancel(notificationId1);
      await flutterLocalNotificationsPlugin.cancel(notificationId2);
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  int _hashUuid(String uuid) {
    var bytes = utf8.encode(uuid);
    var digest = sha1.convert(bytes);
    return digest.bytes.fold(0, (sum, byte) => sum + byte);
  }

  Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.notification.request();
    }
    return status == PermissionStatus.granted;
  }

  Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 31) {
        var status = await Permission.scheduleExactAlarm.request();
        if (status.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }
}
