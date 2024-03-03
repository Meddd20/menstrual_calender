import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:d_chart/d_chart.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/period_cycle_controller.dart';

class PeriodCycleView extends GetView<PeriodCycleController> {
  const PeriodCycleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PeriodCycleController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeriodCycleView'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        tooltip: 'Add Period Cycle',
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            "Add Period Cycle",
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
                                          "Update the start and end dates of a specific time period for precise and current tracking.",
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
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Iconsax.calendar),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start Date",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "${DateFormat('yyyy-MM-dd').format(controller.startDate.value ?? DateTime.now())}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "End Date",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Obx(
                                          () => Container(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "${DateFormat('yyyy-MM-dd').format(controller.endDate.value ?? DateTime.now())}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.w),
                                    Icon(Iconsax.calendar),
                                  ],
                                ),
                              )
                            ],
                          ),
                          CustomCalendarDatePicker(
                            value: [
                              controller.startDate.value,
                              controller.endDate.value
                            ],
                            onValueChanged: (dates) {
                              if (dates.first != null) {
                                controller.setStartDate(dates.first);

                                final avgPeriodDuration = controller
                                        .periodCycleData
                                        .first
                                        .data
                                        ?.avgPeriodDuration ??
                                    8;

                                if (dates.last != null) {
                                  controller.setEndDate(dates.last);
                                } else {
                                  final lastDate = dates.first!
                                      .add(Duration(days: avgPeriodDuration));

                                  controller.setEndDate(lastDate);
                                }

                                controller.update();
                              }
                            },
                            lastDate: DateTime.now(),
                            calendarType: CalendarDatePicker2Type.range,
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () {
                              controller.addPeriod(controller.periodCycleData
                                      .first.data?.avgPeriodDuration ??
                                  8);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size(Get.width, 45.h)),
                            child: Text(
                              "Add Period",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.38,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ],
                );
              }).then((value) {
            controller.cancelEdit();
          });
        },
      ),
      body: Obx(() {
        var periodHistoryList = controller.periodCycleData.isEmpty
            ? null
            : controller.periodCycleData.first.data?.periodChart;
        if (controller.periodCycleData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: periodHistoryList?.length ?? 0,
            itemBuilder: (context, index) {
              var periodHistory = periodHistoryList?[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0),
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
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Edit Period",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                      Get.back();
                                                    },
                                                  )
                                                  // GestureDetector(
                                                  //   onTap: () {},
                                                  //   child: Text(
                                                  //     "Reset",
                                                  //     style: TextStyle(
                                                  //       color: Color(0xFFFD6666),
                                                  //       fontWeight:
                                                  //           FontWeight.w700,
                                                  //       fontSize: 18,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(height: 4.h),
                                              Container(
                                                width: Get.width,
                                                child: Text(
                                                  "Update the start and end dates of a specific time period for precise and current tracking.",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
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
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Iconsax.calendar),
                                            SizedBox(width: 10.w),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Start Date",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Obx(
                                                  () => Container(
                                                    padding: EdgeInsets.only(
                                                        top: 4.0),
                                                    child: Text(
                                                      "${DateFormat('yyyy-MM-dd').format(controller.startDate.value!)}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "End Date",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Obx(
                                                  () => Container(
                                                    padding: EdgeInsets.only(
                                                        top: 4.0),
                                                    child: Text(
                                                      "${DateFormat('yyyy-MM-dd').format(controller.endDate.value!)}",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10.w),
                                            Icon(Iconsax.calendar),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    child: CalendarDatePicker2(
                                      config: CalendarDatePicker2Config(
                                        calendarType:
                                            CalendarDatePicker2Type.range,
                                        weekdayLabels: [
                                          'Sun',
                                          'Mon',
                                          'Tue',
                                          'Wed',
                                          'Thu',
                                          'Fri',
                                          'Sat'
                                        ],
                                        firstDayOfWeek: 1,
                                        controlsHeight: 50,
                                        controlsTextStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        centerAlignModePicker: true,
                                        customModePickerIcon: const SizedBox(),
                                        selectedDayHighlightColor:
                                            Color(0xFFFF6868),
                                        weekdayLabelTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                        dayTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                        selectedDayTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      value: [
                                        DateTime.parse(
                                            '${periodHistory?.startDate}'),
                                        DateTime.parse(
                                            '${periodHistory?.endDate}'),
                                      ],
                                      onValueChanged: (dates) {
                                        controller.setStartDate(dates.first);
                                        controller.setEndDate(dates.last);
                                        controller.update();
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (periodHistory?.id != null) {
                                        controller.editPeriod(
                                            periodHistory!.id!,
                                            periodHistory.periodCycle);
                                      } else {}
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFFD6666),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize: Size(Get.width, 45.h),
                                    ),
                                    child: Text(
                                      "Update Period",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.38,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      shadowColor: Colors.transparent,
                                      minimumSize:
                                          Size(Get.width, Get.height * 0.06),
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16.sp,
                                        letterSpacing: 0.38,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).then((value) {
                    controller.cancelEdit();
                  });
                  controller.setStartDate(
                      DateTime.parse('${periodHistory?.startDate}'));
                  controller
                      .setEndDate(DateTime.parse('${periodHistory?.endDate}'));
                  controller.update();
                },
                child: ListTile(
                  // selectedTileColor:
                  //     periodHistory?.isActual == 0 ? Colors.black : Colors.blue,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${periodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${periodHistory.startDate}')) : "N/A"} - ${periodHistory != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse('${periodHistory.endDate}')) : "N/A"}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      // Text(
                      //   controller.setActual(periodHistory?.isActual),
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.w400,
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        height: 22,
                        child: DChartSingleBar(
                          foregroundColor: Color(0xFFFD6666),
                          value:
                              periodHistory?.periodDuration?.toDouble() ?? 0.0,
                          max: periodHistory?.periodCycle?.toDouble() ?? 0.0,
                          backgroundLabel: Text(
                            "${periodHistory?.periodCycle ?? 0} days",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          backgroundLabelAlign: Alignment.centerRight,
                          backgroundLabelPadding: EdgeInsets.only(right: 10.0),
                          foregroundLabel: Text(
                            "${periodHistory?.periodDuration ?? 0} days",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          foregroundLabelAlign: Alignment.centerLeft,
                          foregroundLabelPadding: EdgeInsets.only(left: 10.0),
                          radius: BorderRadius.all(Radius.circular(5)),
                          // onBackground: (),
                          // onForeground: (),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
