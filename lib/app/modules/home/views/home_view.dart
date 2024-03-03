import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/reminder_view.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/widgets/custom_border_card.dart';
import 'package:periodnpregnancycalender/app/repositories/period_repository.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/daily_log_view.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/views/period_cycle_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PageController _pageController =
        PageController(viewportFraction: 0.8);
    final ApiService apiService = ApiService();
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: AppBar(
              title: Text(
                'Your cycle',
                style: TextStyle(
                  fontFamily: "Popins",
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.notification),
                )
              ],
              centerTitle: true,
              elevation: 0.0,
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_home,
          animatedIconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          spaceBetweenChildren: 6,
          children: [
            SpeedDialChild(
              child: Icon(Iconsax.omega_circle),
              label: "Add Period",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Iconsax.omega_circle),
              label: "Period Cycle",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Iconsax.omega_circle),
              label: "Daily Log",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {},
            ),
            SpeedDialChild(
              child: Icon(Iconsax.omega_circle),
              label: "Reminder",
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {},
            ),
          ],
        ),
        body: FutureBuilder<PeriodCycle?>(
          future: PeriodRepository(apiService).getPeriodSummary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text("No data available");
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0),
                child: Align(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCalendar(
                          isExpandable: true,
                          onDateSelected: (DateTime selectedDate) {
                            controller.setSelectedDate(selectedDate);
                          },
                          dayBuilder: (BuildContext context, DateTime day) {
                            bool isSelectedDay = controller.selectedDate?.day ==
                                    day.day &&
                                controller.selectedDate?.month == day.month &&
                                controller.selectedDate?.year == day.year;

                            bool menstruation = false;
                            bool ovulation = false;
                            bool fertilePeriod = false;
                            bool predictMenstruation = false;
                            bool predictOvulation = false;
                            bool predictFertilePeriod = false;

                            for (int i = 0;
                                i < controller.haidAwalList.length;
                                i++) {
                              DateTime haidAwal = controller.haidAwalList[i];
                              DateTime haidAkhir = controller.haidAkhirList[i];

                              if (day.isAtSameMomentAs(haidAwal) ||
                                  day.isAfter(haidAwal) &&
                                      day.isBefore(haidAkhir) ||
                                  day.isAtSameMomentAs(haidAkhir)) {
                                menstruation = true;
                                break;
                              }
                            }

                            for (int j = 0;
                                j < controller.ovulasiList.length;
                                j++) {
                              DateTime ovulasi = controller.ovulasiList[j];

                              if (day.isAtSameMomentAs(ovulasi)) {
                                ovulation = true;
                                break;
                              }
                            }

                            for (int i = 0;
                                i < controller.masaSuburAwalList.length;
                                i++) {
                              DateTime masaSuburAwal =
                                  controller.masaSuburAwalList[i];
                              DateTime masaSuburAkhir =
                                  controller.masaSuburAkhirList[i];

                              if (day.isAtSameMomentAs(masaSuburAwal) ||
                                  day.isAfter(masaSuburAwal) &&
                                      day.isBefore(masaSuburAkhir) ||
                                  day.isAtSameMomentAs(masaSuburAkhir)) {
                                fertilePeriod = true;
                                break;
                              }
                            }

                            for (int i = 0;
                                i < controller.predictHaidAwalList.length;
                                i++) {
                              DateTime predictHaidAwal =
                                  controller.predictHaidAwalList[i];
                              DateTime predictHaidAkhir =
                                  controller.predictHaidAkhirList[i];

                              if ((day.isAtSameMomentAs(predictHaidAwal) ||
                                  day.isAfter(predictHaidAwal) &&
                                      day.isBefore(predictHaidAkhir) ||
                                  day.isAtSameMomentAs(predictHaidAkhir))) {
                                predictMenstruation = true;
                                break;
                              }
                            }

                            for (int j = 0;
                                j < controller.predictOvulasiList.length;
                                j++) {
                              DateTime predictOvulasi =
                                  controller.predictOvulasiList[j];
                              if (day.isAtSameMomentAs(predictOvulasi)) {
                                predictOvulation = true;
                                break;
                              }
                            }

                            for (int i = 0;
                                i < controller.predictMasaSuburAwalList.length;
                                i++) {
                              DateTime predictMasaSuburAwal =
                                  controller.predictMasaSuburAwalList[i];
                              DateTime predictMasaSuburAkhir =
                                  controller.predictMasaSuburAkhirList[i];
                              if ((day.isAtSameMomentAs(predictMasaSuburAwal) ||
                                  day.isAfter(predictMasaSuburAwal) &&
                                      day.isBefore(predictMasaSuburAkhir) ||
                                  day.isAtSameMomentAs(
                                      predictMasaSuburAkhir))) {
                                predictFertilePeriod = true;
                                break;
                              }
                            }

                            bool isInCurrentMonth =
                                day.month == controller.selectedDate?.month;

                            return Container(
                              margin: EdgeInsetsDirectional.only(top: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelectedDay
                                    ? Colors.pink
                                    : menstruation
                                        ? Colors.blue
                                        : ovulation
                                            ? Colors.green
                                            : fertilePeriod
                                                ? Colors.indigo
                                                : Colors.transparent,
                              ),
                              child: Center(
                                child: predictMenstruation
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: DottedBorder(
                                          borderType: BorderType.Circle,
                                          dashPattern: [8, 2, 1, 4],
                                          color: Colors.pink,
                                          strokeWidth: 2.0,
                                          child: Center(
                                            child: Text(
                                              '${day.day}',
                                              style: TextStyle(
                                                color: isInCurrentMonth
                                                    ? Colors.black
                                                    : Colors.grey,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : predictOvulation
                                        ? Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: DottedBorder(
                                              borderType: BorderType.Circle,
                                              dashPattern: [8, 2, 1, 4],
                                              color: Colors.blue,
                                              strokeWidth: 2.0,
                                              child: Center(
                                                child: Text(
                                                  '${day.day}',
                                                  style: TextStyle(
                                                    color: isInCurrentMonth
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : predictFertilePeriod
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: DottedBorder(
                                                  borderType: BorderType.Circle,
                                                  dashPattern: [8, 2, 1, 4],
                                                  color:
                                                      Colors.lightGreenAccent,
                                                  strokeWidth: 2.0,
                                                  child: Center(
                                                    child: Text(
                                                      '${day.day}',
                                                      style: TextStyle(
                                                        color: isInCurrentMonth
                                                            ? Colors.black
                                                            : Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  '${day.day}',
                                                  style: TextStyle(
                                                    color: isSelectedDay
                                                        ? Colors.white
                                                        : isInCurrentMonth
                                                            ? Colors.black
                                                            : Colors.grey,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          width: Get.width,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFFD7DF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                                              text: controller.getOrdinalSuffix(
                                                  controller.eventDatas.value
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
                                SizedBox(height: 20.h),
                                Divider(),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => PeriodCycleView());
                                  },
                                  child: Container(
                                    child: Align(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Detail period",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              height: 2.0,
                                              color: Color(0xFF6A707C),
                                            ),
                                          ),
                                          Icon(
                                            Iconsax.arrow_right_34,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DailyLogView());
                          },
                          child: Container(
                            width: Get.width,
                            decoration: ShapeDecoration(
                              color: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(
                                        right:
                                            10.0), // Tambahkan margin ke kanan
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFFFC7C7).withOpacity(0.5),
                                    ),
                                    child: Image.asset(
                                      'assets/image/free-diary-3985327-3317725-558049889.png',
                                      color: Color(0xFFFF6868),
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: Get.width,
                                            child: Text(
                                              'Day\'s data',
                                              style: TextStyle(
                                                color: Color(0xFF090A0A),
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'It allows us to determine your chance of getting pregnant on a given day',
                                            style: TextStyle(
                                              color: Color(0xFF090A0A),
                                              fontSize: 13,
                                              fontFamily: 'Poppins',
                                              // fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Iconsax.add_circle5,
                                    color: Color(0xFFFF6868),
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: (() => Get.to(() => ReminderView())),
                          child: Container(
                            width: Get.width,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Iconsax.clock4),
                                  SizedBox(width: 20.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Custom Reminder",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          height: 2.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Iconsax.add4),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35.h),
                        Text(
                          'Next Cycle',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 0.08,
                          ),
                        ),
                        SizedBox(height: 35.h),
                        Container(
                          height: 150.h,
                          child: ListView(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: CustomBorderCard(
                                  width: Get.width - 100,
                                  height: double.infinity,
                                  color: Color(0xFFFFD7DF),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, right: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 80.h,
                                          child: Image.asset(
                                            "assets/image/2bb0bcaf2c98e3d209d65f244fe05400.png",
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15.h),
                                              Text(
                                                'Next period',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '${controller.formatDate(controller.eventDatas.value.nextMenstruationStart)} - ${controller.formatDate(controller.eventDatas.value.nextMenstruationEnd)}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  )),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '(${controller.eventDatas.value.daysUntilNextMenstruation} Days Left)',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.74),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: CustomBorderCard(
                                  width: Get.width - 100,
                                  height: double.infinity,
                                  color: Color(0x7FA5F9FF),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, right: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 80.h,
                                          child: Image.asset(
                                            "assets/image/c05bebf624f24e4c75f0a2c86c84ef88.png",
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15.h),
                                              Text(
                                                'Next ovulation',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '${controller.formatDate(controller.eventDatas.value.nextOvulation)}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  )),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '(${controller.eventDatas.value.daysUntilNextOvulation} Days Left)',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.7400000095367432),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: CustomBorderCard(
                                  width: Get.width - 100,
                                  height: double.infinity,
                                  color: Color(0xFFC6FCE5),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, right: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 80.h,
                                          child: Image.asset(
                                            "assets/image/8b680d9c9dbe5efd752b6546c263ce23.png",
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15.h),
                                              Text(
                                                'Fertile days',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '${controller.formatDate(controller.eventDatas.value.nextFertileStart)} - ${controller.formatDate(controller.eventDatas.value.nextFertileEnd)}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  )),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '(${controller.eventDatas.value.daysUntilNextFertile} Days Left)',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.7400000095367432),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: CustomBorderCard(
                                  width: Get.width - 100,
                                  height: double.infinity,
                                  color: Color(0xFFFFE69E),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15.0, bottom: 15.0, right: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 80.w,
                                          height: 80.h,
                                          child: Image.asset(
                                            "assets/image/ff118d5b4ec2622460cd6bc27a27aeb0.png",
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 15.h),
                                              Text(
                                                'Safe days',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '${controller.formatDate(controller.eventDatas.value.nextLutealStart)} - ${controller.formatDate(controller.eventDatas.value.nextLutealEnd)}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  )),
                                              SizedBox(height: 5.h),
                                              Obx(() => Text(
                                                    '(${controller.eventDatas.value.daysUntilNextLuteal} Days Left)',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.7400000095367432),
                                                      fontSize: 14.sp,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      letterSpacing: 0.38,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
