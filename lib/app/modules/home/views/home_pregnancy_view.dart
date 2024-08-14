import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_weekly_info.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_pregnancy_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/detail_pregnancy_view.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePregnancyView extends GetView<HomePregnancyController> {
  const HomePregnancyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomePregnancyController());
    return SafeArea(
      child: Scaffold(
          body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: ((context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Pregnancy Mode',
                  style: CustomTextStyle.extraBold(22),
                ),
              ),
              centerTitle: true,
              snap: false,
            )
          ];
        }),
        body: FutureBuilder(
          future: controller.pregnancyData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                child: Align(
                  child: Obx(
                    () {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            CircularStepProgressIndicator(
                              totalSteps: 40,
                              currentStep: (controller.getPregnancyIndex ?? 0) + 1,
                              stepSize: 10,
                              selectedColor: Colors.greenAccent,
                              unselectedColor: Colors.grey[200],
                              padding: 0,
                              width: 320,
                              height: 320,
                              selectedStepSize: 15,
                              startingAngle: math.pi,
                              roundedCap: (_, __) => true,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/image/fetal_development/${controller.weeklyData[(controller.getPregnancyIndex ?? 0)].bayiImgPath}',
                                  fit: BoxFit.contain,
                                ),
                                clipBehavior: Clip.antiAlias,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Visibility(
                                    visible: (controller.getPregnancyIndex! > 0),
                                    replacement: SizedBox(
                                      width: 30.dg,
                                      height: 30.dg,
                                    ),
                                    child: CustomCircularIcon(
                                      iconData: Icons.arrow_back_ios_new,
                                      iconSize: 20,
                                      iconColor: Color(0xFF878686),
                                      containerColor: Color(0xFFD4D2D2),
                                      containerSize: 15.dg,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.pregnancyIndexBackward();
                                  },
                                ),
                                Text(
                                  "${(controller.getPregnancyIndex ?? 0) + 1} Weeks Pregnant",
                                  style: CustomTextStyle.extraBold(24, height: 1.5),
                                ),
                                GestureDetector(
                                  child: Visibility(
                                    visible: (controller.getPregnancyIndex! < 39),
                                    replacement: SizedBox(
                                      width: 30.dg,
                                      height: 30.dg,
                                    ),
                                    child: CustomCircularIcon(
                                      iconData: Icons.arrow_forward_ios_outlined,
                                      iconSize: 20,
                                      iconColor: Color(0xFF878686),
                                      containerColor: Color(0xFFD4D2D2),
                                      containerSize: 15.dg,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.pregnancyIndexForward();
                                  },
                                ),
                              ],
                            ),
                            Text(
                              "${controller.formatDate(controller.weeklyData[controller.currentPregnancyWeekIndex.value].tanggalAwalMinggu ?? "")} - ${controller.formatDate(controller.weeklyData[controller.currentPregnancyWeekIndex.value].tanggalAkhirMinggu ?? "")}",
                              style: CustomTextStyle.semiBold(18, height: 1.5),
                            ),
                            Text(
                              "(${controller.weeklyData[controller.currentPregnancyWeekIndex.value].mingguLabel})",
                              style: CustomTextStyle.regular(14, height: 1.5),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          StepProgressIndicator(
                                            totalSteps: 12,
                                            currentStep: ((controller.getPregnancyIndex ?? 0) + 1).clamp(0, 12),
                                            size: 5,
                                            padding: 0,
                                            selectedColor: Colors.yellow,
                                            unselectedColor: Colors.cyan,
                                            roundedEdges: Radius.circular(10),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Due date",
                                                textAlign: TextAlign.center,
                                                style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext context) {
                                                        return Padding(
                                                          padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 20.h),
                                                          child: Wrap(
                                                            children: [
                                                              Obx(
                                                                () => Column(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.transparent,
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: TableCalendar(
                                                                        focusedDay: controller.getFocusedDate,
                                                                        firstDay: DateTime.now().subtract(Duration(days: 280)),
                                                                        lastDay: DateTime.now(),
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
                                                                          formatButtonVisible: false,
                                                                          leftChevronVisible: true,
                                                                          rightChevronVisible: true,
                                                                          titleCentered: true,
                                                                          formatButtonDecoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                              color: Colors.black,
                                                                              width: 2,
                                                                            ),
                                                                            color: Colors.red,
                                                                          ),
                                                                          titleTextStyle: CustomTextStyle.bold(16),
                                                                          headerMargin: EdgeInsets.only(bottom: 10),
                                                                        ),
                                                                        availableGestures: AvailableGestures.all,
                                                                        calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
                                                                          return Center(
                                                                            child: Text(
                                                                              DateFormat.E().format(day),
                                                                              style: CustomTextStyle.regular(14),
                                                                            ),
                                                                          );
                                                                        }, defaultBuilder: (context, day, focusedDay) {
                                                                          return Container(
                                                                            child: Center(
                                                                              child: Text(
                                                                                '${day.day}',
                                                                                style: CustomTextStyle.bold(16),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }, selectedBuilder: (context, day, focusedDay) {
                                                                          return Container(
                                                                            margin: EdgeInsets.all(6),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepPurpleAccent,
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                '${day.day}',
                                                                                style: CustomTextStyle.bold(16, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }, todayBuilder: (context, day, focusedDay) {
                                                                          return Container(
                                                                            margin: EdgeInsets.all(6),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.deepPurpleAccent[100],
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                '${day.day}',
                                                                                style: CustomTextStyle.bold(16, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }, markerBuilder: (context, day, events) {
                                                                          if (day.isAtSameMomentAs(DateTime.parse(controller.currentlyPregnantData.value.hariPertamaHaidTerakhir ?? "${DateTime.now()}"))) {
                                                                            return Container(
                                                                              width: 10.0,
                                                                              height: 10.0,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.deepPurpleAccent[100],
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                            );
                                                                          }
                                                                          return null;
                                                                        }),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 20,
                                                                    ),
                                                                    CustomButton(
                                                                      text: "Send",
                                                                      onPressed: () {
                                                                        controller.editPregnancyStartDate();
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 16,
                                                  color: Colors.black.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${DateFormat('yyyy-MM-dd').format(DateTime.parse(controller.currentlyPregnantData.value.tanggalPerkiraanLahir!))}",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.bold(15, height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          StepProgressIndicator(
                                            totalSteps: 16,
                                            currentStep: (((controller.getPregnancyIndex ?? 0) + 1) - 12).clamp(0, 16),
                                            size: 5,
                                            padding: 0,
                                            selectedColor: Colors.yellow,
                                            unselectedColor: Colors.cyan,
                                            roundedEdges: Radius.circular(10),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Trimester",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].trimester ?? ""}",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.bold(15, height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          StepProgressIndicator(
                                            totalSteps: 12,
                                            currentStep: (((controller.getPregnancyIndex ?? 0) + 1) - 28).clamp(0, 12),
                                            size: 5,
                                            padding: 0,
                                            selectedColor: Colors.yellow,
                                            unselectedColor: Colors.cyan,
                                            roundedEdges: Radius.circular(10),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Due date",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                          ),
                                          Text(
                                            "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].mingguSisa ?? ""}W",
                                            textAlign: TextAlign.center,
                                            style: CustomTextStyle.bold(15, height: 1.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: controller.weeklyData[controller.currentPregnancyWeekIndex.value].ukuranBayi != null,
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Baby is as big as",
                                                  textAlign: TextAlign.center,
                                                  style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                                ),
                                                Container(
                                                  child: Text(
                                                    "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].ukuranBayi ?? ""}",
                                                    style: CustomTextStyle.extraBold(20, height: 1.5),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            'assets/image/baby_comparison/${controller.weeklyData[(controller.getPregnancyIndex ?? 0)].ukuranBayiImgPath}',
                                            width: 80,
                                            fit: BoxFit.cover,
                                            // height: 100,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.monitor_weight,
                                                        size: 14,
                                                        color: Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " Ideal weight",
                                                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].beratJanin ?? "-"} g",
                                                textAlign: TextAlign.center,
                                                style: CustomTextStyle.extraBold(18, height: 1.5),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 40,
                                            child: VerticalDivider(
                                              thickness: 1,
                                              color: Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Icon(
                                                        Icons.height,
                                                        size: 14,
                                                        color: Colors.black.withOpacity(0.6),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " Ideal height",
                                                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].tinggiBadanJanin ?? "-"} mm",
                                                textAlign: TextAlign.center,
                                                style: CustomTextStyle.extraBold(20, height: 1.5),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    WeeklyInfo(
                                      title: "This Week's Highlight",
                                      imagePath: 'assets/icon/sticky-note.png',
                                      onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: "Highlight"), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].poinUtama),
                                    ),
                                    SizedBox(width: 10),
                                    WeeklyInfo(
                                      title: "Body Changes This Week",
                                      imagePath: 'assets/icon/pregnant.png',
                                      onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: "Body Changes"), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].perubahanTubuh),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    WeeklyInfo(
                                      title: "Your Baby This Week",
                                      imagePath: 'assets/icon/pregnancy.png',
                                      onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: "Your Baby Development"), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].perkembanganBayi),
                                    ),
                                    SizedBox(width: 10),
                                    WeeklyInfo(
                                      title: "Symptoms You Might Feel",
                                      imagePath: 'assets/icon/morning-sickness.png',
                                      onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: "Symptoms"), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].gejalaUmum),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    WeeklyInfo(
                                      title: "Things To Consider",
                                      imagePath: 'assets/icon/list.png',
                                      onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: "Things to Consider"), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].tipsMingguan),
                                    ),
                                    SizedBox(width: 10),
                                    Spacer()
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      )),
    );
  }
}
