import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_add_period_bottom_sheet.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_card_predictions.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/chinese_pred_detail_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/daily_log_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/shettles_pred_detail_view.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home_menstruation_controller.dart';

class HomeMenstruationView extends GetView<HomeMenstruationController> {
  const HomeMenstruationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: ((context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                floating: true,
                title: Text('Appbar'),
                centerTitle: true,
                // snap: true,
              )
            ];
          }),
          body: FutureBuilder(
            future: controller.periodStream,
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
                                    for (int i = 0; i < controller.haidAwalList.length; i++) {
                                      if (day.isAtSameMomentAs(controller.haidAwalList[i]) || day.isAfter(controller.haidAwalList[i]) && day.isBefore(controller.haidAkhirList[i]) || day.isAtSameMomentAs(controller.haidAkhirList[i]))
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

                                    for (int j = 0; j < controller.ovulasiList.length; j++) {
                                      if (day.isAtSameMomentAs(controller.ovulasiList[j])) {
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

                                    for (int i = 0; i < controller.masaSuburAwalList.length; i++) {
                                      if (day.isAtSameMomentAs(controller.masaSuburAwalList[i]) || day.isAfter(controller.masaSuburAwalList[i]) && day.isBefore(controller.masaSuburAkhirList[i]) || day.isAtSameMomentAs(controller.masaSuburAkhirList[i])) {
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

                                    for (int i = 0; i < controller.predictHaidAwalList.length; i++) {
                                      if ((day.isAtSameMomentAs(controller.predictHaidAwalList[i]) || day.isAfter(controller.predictHaidAwalList[i]) && day.isBefore(controller.predictHaidAkhirList[i]) || day.isAtSameMomentAs(controller.predictHaidAkhirList[i]))) {
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

                                    for (int j = 0; j < controller.predictOvulasiList.length; j++) {
                                      if (day.isAtSameMomentAs(controller.predictOvulasiList[j])) {
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

                                    for (int i = 0; i < controller.predictMasaSuburAwalList.length; i++) {
                                      if ((day.isAtSameMomentAs(controller.predictMasaSuburAwalList[i]) || day.isAfter(controller.predictMasaSuburAwalList[i]) && day.isBefore(controller.predictMasaSuburAkhirList[i]) || day.isAtSameMomentAs(controller.predictMasaSuburAkhirList[i]))) {
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
                                  markerBuilder: (context, day, events) {
                                    for (var prediction in controller.data?.shettlesGenderPrediction ?? []) {
                                      if ((day.isAtSameMomentAs(prediction.boyStartDate ?? DateTime.now()) || day.isAfter(prediction.boyStartDate ?? DateTime.now()) && day.isBefore(prediction.boyEndDate ?? DateTime.now()) || day.isAtSameMomentAs(prediction.boyEndDate ?? DateTime.now()))) {
                                        return Align(
                                          alignment: Alignment.bottomRight,
                                          child: SvgPicture.asset(
                                            'assets/image/baby-boy.svg',
                                            height: 25,
                                          ),
                                        );
                                      }

                                      if ((day.isAtSameMomentAs(prediction.girlStartDate ?? DateTime.now()) || day.isAfter(prediction.girlStartDate ?? DateTime.now())) && (day.isBefore(prediction.girlEndDate ?? DateTime.now()) || day.isAtSameMomentAs(prediction.girlEndDate ?? DateTime.now()))) {
                                        return Align(
                                          alignment: Alignment.bottomRight,
                                          child: SvgPicture.asset(
                                            'assets/image/baby-girl.svg',
                                            height: 25,
                                          ),
                                        );
                                      }
                                    }
                                    return Container();
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                text: "${controller.eventDatas.value.cycleDay ?? 'null'}",
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 24,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: controller.getOrdinalSuffix(controller.eventDatas.value.cycleDay ?? 0),
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0xFFFFD7DF),
                                      primaryColor: AppColors.primary,
                                      daysLeft: '${controller.eventDatas.value.daysUntilNextMenstruation} Days Left',
                                      predictionType: 'Period',
                                      datePrediction: "${controller.formatDate(controller.eventDatas.value.nextMenstruationStart)} - ${controller.formatDate(controller.eventDatas.value.nextMenstruationEnd)}",
                                      iconPath: 'assets/icon/blood.png',
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0xFFFFE69E),
                                      primaryColor: Color(0xFFFD9414),
                                      daysLeft: '${controller.eventDatas.value.daysUntilNextFertile} Days Left',
                                      predictionType: 'Fertile days',
                                      datePrediction: '${controller.formatDate(controller.eventDatas.value.nextFertileStart)} - ${controller.formatDate(controller.eventDatas.value.nextFertileEnd)}',
                                      iconPath: 'assets/icon/sunflower.png',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0x7FA5F9FF),
                                      primaryColor: Color.fromARGB(255, 64, 176, 184),
                                      daysLeft: '${controller.eventDatas.value.daysUntilNextOvulation} Days Left',
                                      predictionType: 'Ovulation',
                                      datePrediction: '${controller.formatDate(controller.eventDatas.value.nextOvulation)}',
                                      iconPath: 'assets/icon/ovulation.png',
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0xFFC6FCE5),
                                      primaryColor: Color.fromARGB(255, 111, 200, 161),
                                      daysLeft: '${controller.eventDatas.value.daysUntilNextLuteal} Days Left',
                                      predictionType: 'Safe days',
                                      datePrediction: '${controller.formatDate(controller.eventDatas.value.nextLutealStart)} - ${controller.formatDate(controller.eventDatas.value.nextLutealEnd)}',
                                      iconPath: 'assets/icon/shield.png',
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
                              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "My Cycle",
                                        style: CustomTextStyle.heading4TextStyle(),
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Text(
                                              "See more",
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(0.6),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 100.h,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Color(0xFFFFD7DF),
                                              border: Border.all(
                                                color: AppColors.primary,
                                                width: 0.5,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Average Cycle Length",
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${controller.data?.avgPeriodCycle}",
                                                          style: TextStyle(
                                                            fontSize: 23.sp,
                                                            fontFamily: 'Poppins',
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w800,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " days",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontFamily: 'Poppins',
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
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
                                              borderRadius: BorderRadius.circular(12),
                                              // color: Color(0xFFFFE69E),
                                              border: Border.all(
                                                color: Color(0xFFFD9414),
                                                width: 0.5,
                                              ),
                                              color: Color(0xFFFFE69E),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Average Period Length",
                                                    style: TextStyle(
                                                      color: Color(0xFFFD9414),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${controller.data?.avgPeriodDuration}",
                                                          style: TextStyle(
                                                            fontSize: 23.sp,
                                                            fontFamily: 'Poppins',
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " days",
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontFamily: 'Poppins',
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
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
                                          borderRadius: BorderRadius.circular(12),
                                          color: const Color.fromARGB(255, 234, 255, 44),
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
                                              CustomButton(
                                                text: "Reminder",
                                                textColor: Colors.black,
                                                backgroundColor: AppColors.white,
                                                onPressed: () => Get.to(() => ReminderView()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    child: SvgPicture.asset(
                                      'assets/image/reminder.svg',
                                      height: 110,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 320,
                                    width: Get.width / 2 - 20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        height: 320.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
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
                                              CustomButton(
                                                text: "Daily Log",
                                                textColor: Colors.black,
                                                backgroundColor: AppColors.white,
                                                onPressed: () => Get.to(() => DailyLogView()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    child: SvgPicture.asset(
                                      'assets/image/lalla.svg',
                                      width: 200,
                                      height: 150,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Obx(
                            () => Visibility(
                              visible: controller.eventDatas.value.chineseGenderPrediction?.genderPrediction != null,
                              child: Container(
                                height: 350,
                                width: Get.width,
                                // color: Colors.black,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 40,
                                      child: Container(
                                        height: 295.h,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Color(0xFF97B3E4),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    '${controller.eventDatas.value.chineseGenderPrediction?.genderPrediction == 'f' ? 'assets/image/baby-girl.svg' : 'assets/image/baby-boy.svg'}',
                                                    height: 120,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "${controller.eventDatas.value.chineseGenderPrediction?.genderPrediction == 'f' ? 'Girl' : 'Boy'}",
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      height: 1.5,
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Did you know?",
                                                      style: TextStyle(
                                                        fontSize: 22.sp,
                                                        height: 1.5,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      "According to the ancient Chinese gender chart, based on your age and the month of conception, if you were to conceive today, the chart predicts the gender of your future child as ",
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        height: 1.5,
                                                        fontFamily: 'Poppins',
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.to(() => ChinesePredDetailView(), arguments: controller.eventDatas.value.chineseGenderPrediction);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: AppColors.primary,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        minimumSize: Size(50.w, 40.h),
                                                      ),
                                                      child: Text(
                                                        "Learn more",
                                                        style: CustomTextStyle.buttonTextStyle(color: Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 10,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF97B3E4),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Color.fromARGB(255, 68, 99, 153), width: 5.0),
                                          ),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Chinese Gender Calendar",
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                height: 1.5,
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Obx(
                            () => Visibility(
                              visible: controller.eventDatas.value.shettlesGenderPrediction != null,
                              child: Container(
                                width: Get.width,
                                height: 380,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 40,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 335.h,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Color(0xFFC1ECF0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Increase Gender Prediction Probability",
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  height: 1.5,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Obx(() {
                                                return Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Aim for intercourse on ovulation day and the next 2-3 days ',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          height: 1.5,
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'from ${controller.formatDate(controller.eventDatas.value.shettlesGenderPrediction?.boyStartDate.toString())} until ${controller.formatDate(controller.eventDatas.value.shettlesGenderPrediction?.boyEndDate.toString())} to likely conceive a male',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ', and have intercourse from the end of menstruation until three days before ovulation, avoiding sex 2-3 days before ovulation ',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          height: 1.5,
                                                          fontFamily: 'Poppins',
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'from ${controller.formatDate(controller.eventDatas.value.shettlesGenderPrediction?.girlStartDate.toString())} until ${controller.formatDate(controller.eventDatas.value.shettlesGenderPrediction?.girlEndDate.toString())} to likely conceive a female.',
                                                        style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                              SizedBox(height: 5),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.to(() => ShettlesPredDetailView(), arguments: controller.eventDatas.value.shettlesGenderPrediction);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  minimumSize: Size(50.w, 40.h),
                                                ),
                                                child: Text(
                                                  "Learn more",
                                                  style: CustomTextStyle.buttonTextStyle(color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 10,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFC1ECF0),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Color.fromARGB(255, 85, 148, 154), width: 5.0),
                                          ),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Shettles Method",
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                height: 1.5,
                                                fontFamily: 'Poppins',
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10)
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
                              Get.back(closeOverlays: true);
                            },
                            title: "Add Period Cycle",
                            buttonCaption: "Add Period",
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
                              controller.addPeriod(controller.data?.avgPeriodDuration ?? 7, controller.data?.avgPeriodCycle ?? 28);
                            },
                            calenderValue: [controller.startDate.value, controller.endDate.value],
                            calenderOnValueChanged: (dates) {
                              if (dates.first != null) {
                                controller.setStartDate(dates.first);

                                final avgPeriodDuration = controller.data?.avgPeriodDuration;

                                if (dates.last != null) {
                                  controller.setEndDate(dates.last);
                                } else {
                                  final lastDate = dates.first!.add(Duration(days: avgPeriodDuration ?? 8));

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
