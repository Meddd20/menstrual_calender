import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_calendar_datepicker.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/reminder_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ReminderController());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.primary,
          shape: CircleBorder(),
          onPressed: () async {
            bool isNotificationPermissionGranted = await controller.localNotificationService.requestNotificationPermission();
            if (isNotificationPermissionGranted) {
              showModalBottomSheet(
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
                        child: SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                  height: 4.h,
                                  width: 32.w,
                                  margin: EdgeInsets.only(top: 16.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Add New Reminder",
                                                style: CustomTextStyle.extraBold(20),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 25,
                                                  color: Color(0xFFFD6666),
                                                ),
                                                onPressed: () {
                                                  controller.cancelEdit();
                                                  Get.back();
                                                },
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 4.h),
                                          Container(
                                            width: Get.width,
                                            child: Text(
                                              "Adjust the start and end dates for precise and up-to-date reminder information.",
                                              style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                CustomCalendarDatePicker(
                                  value: [controller.getDate()],
                                  onValueChanged: (dates) {
                                    controller.setDate(dates.first);
                                  },
                                  firstDate: DateTime.now(),
                                  calendarType: CalendarDatePicker2Type.single,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Time",
                                        style: CustomTextStyle.semiBold(18),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
                                          if (selectedTime != null) {
                                            controller.setTime(selectedTime);
                                          }
                                        },
                                        child: IntrinsicWidth(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.highlight,
                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                            ),
                                            child: Center(
                                              child: Obx(
                                                () => Text(
                                                  controller.formattedSelectedTime ?? "Select Time",
                                                  style: CustomTextStyle.medium(14, height: 1.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                TextFormField(
                                  onChanged: (text) => controller.updateReminderTitle(text),
                                  decoration: InputDecoration(
                                    hintText: 'Enter reminder title',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.all(18),
                                  ),
                                  style: CustomTextStyle.medium(15),
                                ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  onChanged: (text) => controller.updateReminderDescription(text),
                                  decoration: InputDecoration(
                                    hintText: 'Enter reminder description',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.all(18),
                                  ),
                                  style: CustomTextStyle.medium(15),
                                  maxLines: 2,
                                ),
                                SizedBox(height: 20.h),
                                CustomButton(text: "Add Reminder", onPressed: () => controller.checkReminder(context)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).then((value) {
                controller.cancelEdit();
              });
            } else if (await Permission.notification.isPermanentlyDenied) {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text(
                      "Permission Required",
                      style: CustomTextStyle.bold(22),
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 8.0),
                            child: Text(
                              "Notification permission is required to use this feature. Please enable it in the app settings.",
                              style: CustomTextStyle.medium(15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 15),
                          CustomButton(
                            text: "Open Settings",
                            onPressed: () {
                              Navigator.of(context).pop();
                              openAppSettings();
                            },
                          ),
                          SizedBox(height: 5),
                          CustomButton(
                            text: "Cancel",
                            textColor: AppColors.black,
                            backgroundColor: AppColors.transparent,
                            onPressed: () => Get.back(closeOverlays: true),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            } else {
              bool isGranted = await controller.localNotificationService.requestNotificationPermission();
              if (!isGranted) {
                Get.snackbar(
                  "Permission Denied",
                  "Please allow the app to send notifications to use this feature.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            }
          },
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Reminder',
                  style: CustomTextStyle.extraBold(22),
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              elevation: 4,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(28.w, 0.h, 20.w, 0),
                child: Column(
                  children: [
                    Text(
                      'Set custom alerts for your pregnancy milestones and appointments, so you never miss an important event.',
                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: controller.reminderFuture,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text('No data available')),
                  );
                } else {
                  return Obx(
                    () {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reminder = controller.reminders[index];
                            return ListTile(
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.formatDateTime(reminder.datetime),
                                            style: CustomTextStyle.regular(14, height: 1.5),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            DateFormat('HH:mm a').format(reminder.datetime != null ? DateTime.parse(reminder.datetime!) : DateTime.now()),
                                            style: CustomTextStyle.extraBold(24),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            reminder.title ?? "",
                                            style: CustomTextStyle.semiBold(18, height: 1.75),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.notes, color: Colors.grey),
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                child: Text(
                                                  reminder.description ?? "",
                                                  style: CustomTextStyle.medium(14, height: 1.5),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.deleteReminder(reminder.id ?? "");
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Wrap(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
                                          child: SizedBox(
                                            height: Get.height,
                                            width: Get.width,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 4.h,
                                                    width: 32.w,
                                                    margin: EdgeInsets.only(top: 16.h),
                                                    decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(3.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "Edit Reminder",
                                                                  style: CustomTextStyle.bold(20),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.close,
                                                                    size: 25,
                                                                    color: Color(0xFFFD6666),
                                                                  ),
                                                                  onPressed: () {
                                                                    controller.cancelEdit();
                                                                    Get.back();
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              width: Get.width,
                                                              child: Text(
                                                                "Adjust the start and end dates for precise and up-to-date reminder information.",
                                                                style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.5), height: 1.5),
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  CustomCalendarDatePicker(
                                                    value: [DateTime.parse(reminder.datetime ?? DateTime.now().toString())],
                                                    onValueChanged: (dates) {
                                                      controller.setDate(dates.first);
                                                    },
                                                    firstDate: DateTime.now(),
                                                    calendarType: CalendarDatePicker2Type.single,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Time",
                                                          style: CustomTextStyle.semiBold(18),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.parse(reminder.datetime ?? "")));
                                                            if (selectedTime != null) {
                                                              controller.setTime(selectedTime);
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 40.h,
                                                            width: 80.w,
                                                            decoration: BoxDecoration(
                                                              color: AppColors.highlight,
                                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                            ),
                                                            child: Center(
                                                              child: Obx(
                                                                () => Text(
                                                                  controller.timeSelected.value != null
                                                                      ? '${controller.timeSelected.value!.hour}:${controller.timeSelected.value!.minute.toString().padLeft(2, '0')}'
                                                                      : reminder.datetime != null
                                                                          ? DateFormat('HH:mm').format(DateTime.parse(reminder.datetime ?? TimeOfDay.now().toString()))
                                                                          : "Select Time",
                                                                  style: CustomTextStyle.bold(15),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 15.h),
                                                  TextFormField(
                                                    initialValue: reminder.title,
                                                    onChanged: (text) => controller.updateReminderTitle(text),
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter reminder title',
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      contentPadding: const EdgeInsets.all(18),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  TextFormField(
                                                    initialValue: reminder.description,
                                                    onChanged: (text) => controller.updateReminderDescription(text),
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter reminder description',
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Colors.black),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      contentPadding: const EdgeInsets.all(18),
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  CustomButton(
                                                    text: "Update Reminder",
                                                    onPressed: () {
                                                      controller.editReminder(reminder.id ?? "", reminder.title ?? "", reminder.description ?? "", reminder.datetime ?? "", context);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ).then((value) {
                                  controller.cancelEdit();
                                });
                              },
                            );
                          },
                          childCount: controller.reminders.length,
                        ),
                      );
                    },
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
