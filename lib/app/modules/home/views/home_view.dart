import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/daily_log_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                // shadowColor: Colors.white,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                floating: true,
                title: Text('Appbar'),
                centerTitle: true,
                snap: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ];
          }),
          body: StreamBuilder(
            stream: controller.periodStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
                  child: Align(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CustomCalendar(
                          //   isExpandable: true,
                          //   onDateSelected: (DateTime selectedDate) {
                          //     controller.setSelectedDate(selectedDate);
                          //   },
                          //   dayBuilder: (BuildContext context, DateTime day) {
                          //     bool isSelectedDay = controller.selectedDate?.day ==
                          //             day.day &&
                          //         controller.selectedDate?.month == day.month &&
                          //         controller.selectedDate?.year == day.year;

                          //     bool menstruation = false;
                          //     bool ovulation = false;
                          //     bool fertilePeriod = false;
                          //     bool predictMenstruation = false;
                          //     bool predictOvulation = false;
                          //     bool predictFertilePeriod = false;

                          //     for (int i = 0;
                          //         i < controller.haidAwalList.length;
                          //         i++) {
                          //       DateTime haidAwal = controller.haidAwalList[i];
                          //       DateTime haidAkhir = controller.haidAkhirList[i];

                          //       if (day.isAtSameMomentAs(haidAwal) ||
                          //           day.isAfter(haidAwal) &&
                          //               day.isBefore(haidAkhir) ||
                          //           day.isAtSameMomentAs(haidAkhir)) {
                          //         menstruation = true;
                          //         break;
                          //       }
                          //     }

                          //     for (int j = 0;
                          //         j < controller.ovulasiList.length;
                          //         j++) {
                          //       DateTime ovulasi = controller.ovulasiList[j];

                          //       if (day.isAtSameMomentAs(ovulasi)) {
                          //         ovulation = true;
                          //         break;
                          //       }
                          //     }

                          //     for (int i = 0;
                          //         i < controller.masaSuburAwalList.length;
                          //         i++) {
                          //       DateTime masaSuburAwal =
                          //           controller.masaSuburAwalList[i];
                          //       DateTime masaSuburAkhir =
                          //           controller.masaSuburAkhirList[i];

                          //       if (day.isAtSameMomentAs(masaSuburAwal) ||
                          //           day.isAfter(masaSuburAwal) &&
                          //               day.isBefore(masaSuburAkhir) ||
                          //           day.isAtSameMomentAs(masaSuburAkhir)) {
                          //         fertilePeriod = true;
                          //         break;
                          //       }
                          //     }

                          //     for (int i = 0;
                          //         i < controller.predictHaidAwalList.length;
                          //         i++) {
                          //       DateTime predictHaidAwal =
                          //           controller.predictHaidAwalList[i];
                          //       DateTime predictHaidAkhir =
                          //           controller.predictHaidAkhirList[i];

                          //       if ((day.isAtSameMomentAs(predictHaidAwal) ||
                          //           day.isAfter(predictHaidAwal) &&
                          //               day.isBefore(predictHaidAkhir) ||
                          //           day.isAtSameMomentAs(predictHaidAkhir))) {
                          //         predictMenstruation = true;
                          //         break;
                          //       }
                          //     }

                          //     for (int j = 0;
                          //         j < controller.predictOvulasiList.length;
                          //         j++) {
                          //       DateTime predictOvulasi =
                          //           controller.predictOvulasiList[j];
                          //       if (day.isAtSameMomentAs(predictOvulasi)) {
                          //         predictOvulation = true;
                          //         break;
                          //       }
                          //     }

                          //     for (int i = 0;
                          //         i < controller.predictMasaSuburAwalList.length;
                          //         i++) {
                          //       DateTime predictMasaSuburAwal =
                          //           controller.predictMasaSuburAwalList[i];
                          //       DateTime predictMasaSuburAkhir =
                          //           controller.predictMasaSuburAkhirList[i];
                          //       if ((day.isAtSameMomentAs(predictMasaSuburAwal) ||
                          //           day.isAfter(predictMasaSuburAwal) &&
                          //               day.isBefore(predictMasaSuburAkhir) ||
                          //           day.isAtSameMomentAs(
                          //               predictMasaSuburAkhir))) {
                          //         predictFertilePeriod = true;
                          //         break;
                          //       }
                          //     }

                          //     bool isInCurrentMonth =
                          //         day.month == controller.selectedDate?.month;

                          //     return Container(
                          //       margin: EdgeInsetsDirectional.only(top: 2.0),
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: isSelectedDay
                          //             ? Colors.pink
                          //             : menstruation
                          //                 ? Colors.blue
                          //                 : ovulation
                          //                     ? Colors.green
                          //                     : fertilePeriod
                          //                         ? Colors.indigo
                          //                         : Colors.transparent,
                          //       ),
                          //       child: Center(
                          //         child: predictMenstruation
                          //             ? Padding(
                          //                 padding: const EdgeInsets.all(2.0),
                          //                 child: DottedBorder(
                          //                   borderType: BorderType.Circle,
                          //                   dashPattern: [8, 2, 1, 4],
                          //                   color: Colors.pink,
                          //                   strokeWidth: 2.0,
                          //                   child: Center(
                          //                     child: Text(
                          //                       '${day.day}',
                          //                       style: TextStyle(
                          //                         color: isInCurrentMonth
                          //                             ? Colors.black
                          //                             : Colors.grey,
                          //                         fontWeight: FontWeight.w900,
                          //                         fontSize: 18,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               )
                          //             : predictOvulation
                          //                 ? Padding(
                          //                     padding: const EdgeInsets.all(2.0),
                          //                     child: DottedBorder(
                          //                       borderType: BorderType.Circle,
                          //                       dashPattern: [8, 2, 1, 4],
                          //                       color: Colors.blue,
                          //                       strokeWidth: 2.0,
                          //                       child: Center(
                          //                         child: Text(
                          //                           '${day.day}',
                          //                           style: TextStyle(
                          //                             color: isInCurrentMonth
                          //                                 ? Colors.black
                          //                                 : Colors.grey,
                          //                             fontWeight: FontWeight.w900,
                          //                             fontSize: 18,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   )
                          //                 : predictFertilePeriod
                          //                     ? Padding(
                          //                         padding:
                          //                             const EdgeInsets.all(2.0),
                          //                         child: DottedBorder(
                          //                           borderType: BorderType.Circle,
                          //                           dashPattern: [8, 2, 1, 4],
                          //                           color:
                          //                               Colors.lightGreenAccent,
                          //                           strokeWidth: 2.0,
                          //                           child: Center(
                          //                             child: Text(
                          //                               '${day.day}',
                          //                               style: TextStyle(
                          //                                 color: isInCurrentMonth
                          //                                     ? Colors.black
                          //                                     : Colors.grey,
                          //                                 fontWeight:
                          //                                     FontWeight.w500,
                          //                                 fontSize: 18,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       )
                          //                     : Padding(
                          //                         padding:
                          //                             const EdgeInsets.all(2.0),
                          //                         child: Text(
                          //                           '${day.day}',
                          //                           style: TextStyle(
                          //                             color: isSelectedDay
                          //                                 ? Colors.white
                          //                                 : isInCurrentMonth
                          //                                     ? Colors.black
                          //                                     : Colors.grey,
                          //                             fontWeight: FontWeight.w600,
                          //                             fontSize: 18,
                          //                           ),
                          //                         ),
                          //                       ),
                          //       ),
                          //     );
                          //   },
                          // ),
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 246, 245, 245),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TableCalendar(
                                focusedDay: controller.getFocusedDate,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                availableCalendarFormats: {
                                  CalendarFormat.month: 'Month',
                                  CalendarFormat.week: 'Week',
                                },
                                calendarFormat: controller.getFormat,
                                onFormatChanged: (newFormat) {
                                  controller.setFormat(newFormat);
                                },
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                onDaySelected: (selectedDay, focusedDay) {
                                  controller.setSelectedDate(selectedDay);
                                  controller.setFocusedDate(focusedDay);
                                },
                                onPageChanged: (focusedDay) {
                                  controller.setFocusedDate(focusedDay);
                                },
                                selectedDayPredicate: (day) => isSameDay(
                                  controller.selectedDate,
                                  day,
                                ),
                                rowHeight: 50,
                                daysOfWeekHeight: 25.0,
                                calendarStyle: CalendarStyle(
                                  cellMargin: EdgeInsets.all(6),
                                  outsideDaysVisible: false,
                                  isTodayHighlighted: true,
                                  rangeStartDecoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  rangeEndDecoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  withinRangeDecoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                headerStyle: HeaderStyle(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: AppColors.contrast,
                                  ),
                                  leftChevronVisible: true,
                                  rightChevronVisible: true,
                                  titleCentered: true,
                                  formatButtonShowsNext: false,
                                  formatButtonTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  formatButtonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    color: Colors.red,
                                  ),
                                  titleTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  headerMargin: EdgeInsets.only(bottom: 10),
                                ),
                                availableGestures: AvailableGestures.all,
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    for (int i = 0;
                                        i < controller.haidAwalList.length;
                                        i++) {
                                      if (day.isAtSameMomentAs(
                                              controller.haidAwalList[i]) ||
                                          day.isAfter(
                                                  controller.haidAwalList[i]) &&
                                              day.isBefore(controller
                                                  .haidAkhirList[i]) ||
                                          day.isAtSameMomentAs(
                                              controller.haidAkhirList[i]))
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                    }

                                    for (int j = 0;
                                        j < controller.ovulasiList.length;
                                        j++) {
                                      if (day.isAtSameMomentAs(
                                          controller.ovulasiList[j])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i < controller.masaSuburAwalList.length;
                                        i++) {
                                      if (day.isAtSameMomentAs(controller
                                              .masaSuburAwalList[i]) ||
                                          day.isAfter(controller
                                                  .masaSuburAwalList[i]) &&
                                              day.isBefore(controller
                                                  .masaSuburAkhirList[i]) ||
                                          day.isAtSameMomentAs(controller
                                              .masaSuburAkhirList[i])) {
                                        return Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i <
                                            controller
                                                .predictHaidAwalList.length;
                                        i++) {
                                      if ((day.isAtSameMomentAs(controller
                                              .predictHaidAwalList[i]) ||
                                          day.isAfter(controller
                                                  .predictHaidAwalList[i]) &&
                                              day.isBefore(controller
                                                  .predictHaidAkhirList[i]) ||
                                          day.isAtSameMomentAs(controller
                                              .predictHaidAkhirList[i]))) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.pink,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int j = 0;
                                        j <
                                            controller
                                                .predictOvulasiList.length;
                                        j++) {
                                      if (day.isAtSameMomentAs(
                                          controller.predictOvulasiList[j])) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.blue,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    for (int i = 0;
                                        i <
                                            controller.predictMasaSuburAwalList
                                                .length;
                                        i++) {
                                      if ((day.isAtSameMomentAs(controller
                                              .predictMasaSuburAwalList[i]) ||
                                          day.isAfter(controller
                                                      .predictMasaSuburAwalList[
                                                  i]) &&
                                              day.isBefore(controller
                                                      .predictMasaSuburAkhirList[
                                                  i]) ||
                                          day.isAtSameMomentAs(controller
                                              .predictMasaSuburAkhirList[i]))) {
                                        return Container(
                                          margin: EdgeInsets.all(8),
                                          child: DottedBorder(
                                            borderType: BorderType.Circle,
                                            dashPattern: [8, 2, 1, 4],
                                            color: Colors.green,
                                            strokeWidth: 2.0,
                                            child: Center(
                                              child: Text(
                                                '${day.day}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    return Container(
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  dowBuilder: (context, day) {
                                    return Center(
                                      child: Text(
                                        DateFormat.E().format(day),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  },
                                  selectedBuilder: (context, day, focusedDay) {
                                    return Container(
                                      margin: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  todayBuilder: (context, day, focusedDay) {
                                    return Container(
                                      margin: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurpleAccent[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            width: Get.width,
                            decoration: ShapeDecoration(
                              color: Color(0xFFDFCCFB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() => Text(
                                            "${controller.eventDatas.value.event}",
                                            style: TextStyle(
                                              fontSize: 17.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )),
                                      Obx(
                                        () => Text(
                                          "${DateFormat('MMMM, dd yyyy').format(controller.selectedDate!)}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 35.h),
                                  Text(
                                    "Current cycle",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                    width: Get.width,
                                    child: Obx(() => Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${controller.eventDatas.value.cycleDay ?? 'null'}",
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 24,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: controller
                                                    .getOrdinalSuffix(controller
                                                            .eventDatas
                                                            .value
                                                            .cycleDay ??
                                                        0),
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 20,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' day of the cycle',
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 20,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20.h),
                                  Obx(
                                    () => Text(
                                      "${controller.eventDatas.value.pregnancyChances} chances of getting pregnant",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        // height: 2.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 22.h),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => CustomCardPredictionCycle(
                                      containerColor: Color(0xFFFFD7DF),
                                      primaryColor: AppColors.primary,
                                      daysLeft:
                                          '${controller.eventDatas.value.daysUntilNextMenstruation} Days Left',
                                      predictionType: 'Period',
                                      datePrediction:
                                          "${controller.formatDate(controller.eventDatas.value.nextMenstruationStart)} - ${controller.formatDate(controller.eventDatas.value.nextMenstruationEnd)}",
                                      icons: FontAwesomeIcons.droplet,
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPredictionCycle(
                                      containerColor: Color(0xFFFFE69E),
                                      primaryColor: Color(0xFFFD9414),
                                      daysLeft:
                                          '${controller.eventDatas.value.daysUntilNextFertile} Days Left',
                                      predictionType: 'Fertile days',
                                      datePrediction:
                                          '${controller.formatDate(controller.eventDatas.value.nextFertileStart)} - ${controller.formatDate(controller.eventDatas.value.nextFertileEnd)}',
                                      icons: FontAwesomeIcons.droplet,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => CustomCardPredictionCycle(
                                      containerColor: Color(0x7FA5F9FF),
                                      primaryColor:
                                          Color.fromARGB(255, 64, 176, 184),
                                      daysLeft:
                                          '${controller.eventDatas.value.daysUntilNextOvulation} Days Left',
                                      predictionType: 'Ovulation',
                                      datePrediction:
                                          '${controller.formatDate(controller.eventDatas.value.nextOvulation)}',
                                      icons: Icons.abc,
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPredictionCycle(
                                      containerColor: Color(0xFFC6FCE5),
                                      primaryColor:
                                          Color.fromARGB(255, 111, 200, 161),
                                      daysLeft:
                                          '${controller.eventDatas.value.daysUntilNextLuteal} Days Left',
                                      predictionType: 'Safe days',
                                      datePrediction:
                                          '${controller.formatDate(controller.eventDatas.value.nextLutealStart)} - ${controller.formatDate(controller.eventDatas.value.nextLutealEnd)}',
                                      icons: FontAwesomeIcons.shieldHalved,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            width: Get.width,
                            height: 195.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 16.0, 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "My Cycle",
                                        style:
                                            CustomTextStyle.heading4TextStyle(),
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Text(
                                              "See more",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(Icons.keyboard_arrow_right)
                                          ],
                                        ),
                                        onTap: () {
                                          Get.to(() => PeriodCycleView());
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${controller.data?.actualPeriod.length} cycle history logged",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      height: 2.0,
                                      fontFamily: 'Poppins',
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 100.h,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Color(0xFFFFD7DF),
                                              border: Border.all(
                                                color: AppColors.primary,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Average Cycle Length",
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${controller.data?.avgPeriodCycle}",
                                                          style: TextStyle(
                                                            fontSize: 23.sp,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " days",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 100.h,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              // color: Color(0xFFFFE69E),
                                              border: Border.all(
                                                color: Color(0xFFFD9414),
                                                width: 0.5,
                                              ),
                                              color: Color(0xFFFFE69E),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Average Period Length",
                                                    style: TextStyle(
                                                      color: Color(0xFFFD9414),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "${controller.data?.avgPeriodDuration}",
                                                          style: TextStyle(
                                                            fontSize: 23.sp,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " days",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 320,
                                    width: Get.width / 2 - 20,
                                    // color: Colors.amberAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        height: 320.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromARGB(
                                              255, 234, 255, 44),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 140),
                                              Text(
                                                "Manage Your Period Events",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Track your period cycle and other related events",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.to(() => ReminderView());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  minimumSize:
                                                      Size(Get.width, 45.h),
                                                ),
                                                child: Text(
                                                  "Reminder",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Image.network(
                                      "https://img.freepik.com/free-vector/hand-drawn-menopause-illustration_23-2149355429.jpg?t=st=1710904509~exp=1710908109~hmac=ea56f8e0ee17b0db20d6184670b4273eedd20e363d9d4baa8684987a5428aa9f&w=826",
                                      fit: BoxFit.fitHeight,
                                      // width: Get.width,
                                      height: 150,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 320,
                                    width: Get.width / 2 - 20,
                                    // color: Colors.amberAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        height: 320.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.cyan,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 140),
                                              Text(
                                                "Remark your body changes",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Log your body changes in every cycle",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.to(() => DailyLogView());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  minimumSize:
                                                      Size(Get.width, 45.h),
                                                ),
                                                child: Text(
                                                  "Log",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: Image.network(
                                      "https://img.freepik.com/free-vector/hand-drawn-menopause-illustration_23-2149355429.jpg?t=st=1710904509~exp=1710908109~hmac=ea56f8e0ee17b0db20d6184670b4273eedd20e363d9d4baa8684987a5428aa9f&w=826",
                                      fit: BoxFit.fitHeight,
                                      // width: Get.width,
                                      height: 150,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        extendBodyBehindAppBar: false,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spaceBetweenChildren: 6,
          children: [
            SpeedDialChild(
              child: Icon(Iconsax.add),
              label: "Add Period",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          AddPeriodBottomSheetWidget(
                            closeModalBottomSheet: () async {
                              controller.cancelEdit();
                              Get.back();
                            },
                            title: "Add Period Cycle",
                            startDate: Obx(
                              () => Text(
                                "${DateFormat('yyyy-MM-dd').format(controller.startDate.value ?? DateTime.now())}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            endDate: Obx(
                              () => Text(
                                "${DateFormat('yyyy-MM-dd').format(controller.endDate.value ?? DateTime.now())}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            addPeriodOnPressedButton: () async {
                              controller.addPeriod(
                                  controller.data?.avgPeriodDuration ?? 8);
                              await controller.fetchCycleData();
                              controller.dateSelectedEvent(DateTime.now());
                              Get.offAllNamed(Routes.NAVIGATION_MENU);
                            },
                            calenderValue: [
                              controller.startDate.value,
                              controller.endDate.value
                            ],
                            calenderOnValueChanged: (dates) {
                              if (dates.first != null) {
                                controller.setStartDate(dates.first);

                                final avgPeriodDuration =
                                    controller.data?.avgPeriodDuration;

                                if (dates.last != null) {
                                  controller.setEndDate(dates.last);
                                } else {
                                  final lastDate = dates.first!.add(
                                      Duration(days: avgPeriodDuration ?? 8));

                                  controller.setEndDate(lastDate);
                                }

                                controller.update();
                              }
                            },
                          ),
                        ],
                      );
                    }).then((value) async {
                  controller.cancelEdit();
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Iconsax.edit),
              label: "Edit Period",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                Get.off(() => PeriodCycleView());
              },
            ),
            SpeedDialChild(
              child: Icon(Iconsax.note),
              label: "Daily Log",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                Get.to(() => DailyLogView());
              },
            ),
            SpeedDialChild(
              child: Icon(Iconsax.clock),
              label: "Reminder",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                Get.to(() => ReminderView());
              },
            ),
          ],
        ),
        // body: ,
      ),
    );
  }
}
