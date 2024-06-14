import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/reminder_controller.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ReminderController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ReminderView'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          backgroundColor: AppColors.primary,
          shape: CircleBorder(),
          onPressed: () {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Add New Reminder",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
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
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
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
                                padding: const EdgeInsets.only(
                                    right: 5.0, left: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Time",
                                      style:
                                          CustomTextStyle.heading4TextStyle(),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        TimeOfDay? selectedTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime:
                                                    TimeOfDay.fromDateTime(
                                                        DateTime.now()));
                                        if (selectedTime != null) {
                                          controller.setTime(selectedTime);
                                        }
                                      },
                                      child: IntrinsicWidth(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.highlight,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                          ),
                                          child: Center(
                                            child: Obx(
                                              () => Text(
                                                controller
                                                        .formattedSelectedTime ??
                                                    "Select Time",
                                                style: CustomTextStyle
                                                    .captionTextStyle(),
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
                                onChanged: (text) =>
                                    controller.updateReminderTitle(text),
                                decoration: InputDecoration(
                                  hintText: 'Enter reminder title',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.all(18),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              TextFormField(
                                onChanged: (text) =>
                                    controller.updateReminderDescription(text),
                                decoration: InputDecoration(
                                  hintText: 'Enter reminder description',
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: const EdgeInsets.all(18),
                                ),
                                maxLines: 2,
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () {
                                  controller.storeReminder();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFD6666),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: Size(Get.width, 45.h),
                                ),
                                child: Text(
                                  "Add Reminder",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.38,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: controller.reminderFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = controller.reminders[index];
                      return ListTile(
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 8.0, 10.0, 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller
                                        .formatDateTime(reminder.datetime)),
                                    SizedBox(height: 2.h),
                                    Text(
                                      DateFormat('HH:mm a').format(
                                        reminder.datetime != null
                                            ? DateTime.parse(reminder.datetime!)
                                            : DateTime.now(),
                                      ),
                                      style:
                                          CustomTextStyle.heading1TextStyle(),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      reminder.title ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.notes, color: Colors.grey),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            reminder.description ?? "",
                                            style:
                                                CustomTextStyle.bodyTextStyle(),
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
                                    padding:
                                        EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
                                    child: SizedBox(
                                      height: Get.height,
                                      width: Get.width,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 4.h,
                                              width: 32.w,
                                              margin:
                                                  EdgeInsets.only(top: 16.h),
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(3.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Edit Reminder",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.close,
                                                              size: 25,
                                                              color: Color(
                                                                  0xFFFD6666),
                                                            ),
                                                            onPressed: () {
                                                              controller
                                                                  .cancelEdit();
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
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                          ),
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
                                              value: [
                                                DateTime.parse(reminder
                                                        .datetime ??
                                                    DateTime.now().toString())
                                              ],
                                              onValueChanged: (dates) {
                                                controller.setDate(dates.first);
                                              },
                                              firstDate: DateTime.now(),
                                              calendarType:
                                                  CalendarDatePicker2Type
                                                      .single,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0, left: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: CustomTextStyle
                                                        .heading4TextStyle(),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      TimeOfDay? selectedTime =
                                                          await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay
                                                                  .fromDateTime(
                                                                      DateTime.parse(
                                                                          reminder.datetime ??
                                                                              "")));
                                                      if (selectedTime !=
                                                          null) {
                                                        controller.setTime(
                                                            selectedTime);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40.h,
                                                      width: 80.w,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.highlight,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15.0)),
                                                      ),
                                                      child: Center(
                                                        child: Obx(
                                                          () => Text(
                                                            controller.timeSelected
                                                                        .value !=
                                                                    null
                                                                ? '${controller.timeSelected.value!.hour}:${controller.timeSelected.value!.minute.toString().padLeft(2, '0')}'
                                                                : reminder.datetime !=
                                                                        null
                                                                    ? DateFormat('HH:mm').format(DateTime.parse(reminder
                                                                            .datetime ??
                                                                        TimeOfDay.now()
                                                                            .toString()))
                                                                    : "Select Time",
                                                            style: CustomTextStyle
                                                                .headerCalenderTextStyle(),
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
                                              onChanged: (text) => controller
                                                  .updateReminderTitle(text),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter reminder title',
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(18),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            TextFormField(
                                              initialValue:
                                                  reminder.description,
                                              onChanged: (text) => controller
                                                  .updateReminderDescription(
                                                      text),
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter reminder description',
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(18),
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 20.h),
                                            ElevatedButton(
                                              onPressed: () {
                                                controller.editReminder(
                                                    reminder.id ?? "",
                                                    reminder.title ?? "",
                                                    reminder.description ?? "",
                                                    reminder.datetime ?? "");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFFFD6666),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                minimumSize:
                                                    Size(Get.width, 45.h),
                                              ),
                                              child: Text(
                                                "Update Reminder",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.38,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 5.h),
                                            // ElevatedButton(
                                            //   onPressed: () {
                                            //     controller.cancelEdit();
                                            //     Get.back();
                                            //   },
                                            //   style: ElevatedButton.styleFrom(
                                            //     backgroundColor: Colors.transparent,
                                            //     elevation: 0,
                                            //     shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //             BorderRadius.circular(10)),
                                            //     shadowColor: Colors.transparent,
                                            //     minimumSize: Size(
                                            //         Get.width, Get.height * 0.06),
                                            //   ),
                                            //   child: Text(
                                            //     "Cancel",
                                            //     style: TextStyle(
                                            //       fontFamily: 'Poppins',
                                            //       fontSize: 16.sp,
                                            //       letterSpacing: 0.38,
                                            //       color: Colors.black,
                                            //       fontWeight: FontWeight.bold,
                                            //     ),
                                            //   ),
                                            // ),
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
                  );
                });
              }
            }),
          ),
        ),
      ),
    );
  }
}
