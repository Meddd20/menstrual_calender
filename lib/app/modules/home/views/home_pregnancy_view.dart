import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_circular_icon.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_expanded_calendar.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_weekly_info.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_pregnancy_controller.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/detail_pregnancy_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/end_pregnancy_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/change_purpose_view.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePregnancyView extends GetView<HomePregnancyController> {
  const HomePregnancyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomePregnancyController());
    return controller.storageService.getIsPregnant() == "2" ? pregnancyRecovery(context) : homePregnancy(context);
  }

  Widget homePregnancy(BuildContext context) {
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
                  AppLocalizations.of(context)!.pregnancyMode,
                  style: CustomTextStyle.extraBold(22),
                ),
              ),
              centerTitle: true,
              snap: false,
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => EndPregnancyView()),
                  icon: Icon(Icons.event_busy),
                  tooltip: AppLocalizations.of(context)!.endPregnancy,
                ),
                SizedBox(width: 10),
              ],
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
              return Obx(
                () => Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                  child: Align(
                    child: SingleChildScrollView(
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
                                'assets/image/${controller.weeklyData[(controller.getPregnancyIndex ?? 0)].bayiImgPath}',
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
                                    containerColor: Color(0xFFECECEC),
                                    containerSize: 15.dg,
                                  ),
                                ),
                                onTap: () {
                                  controller.pregnancyIndexBackward();
                                },
                              ),
                              Text(
                                AppLocalizations.of(context)!.weeksPregnant("${(controller.getPregnancyIndex ?? 0) + 1}"),
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
                                    containerColor: Color(0xFFECECEC),
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
                            "${formatDateToMonthDay(controller.weeklyData[controller.currentPregnancyWeekIndex.value].tanggalAwalMinggu ?? "")} - ${formatDateToMonthDay(controller.weeklyData[controller.currentPregnancyWeekIndex.value].tanggalAkhirMinggu ?? "")}",
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Expanded(
                                              child: Text(
                                                AppLocalizations.of(context)!.dueDate,
                                                textAlign: TextAlign.center,
                                                style: CustomTextStyle.medium(11, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                                maxLines: 2,
                                              ),
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
                                                                    child: CustomExpandedCalendar(
                                                                      firstDay: DateTime.now().subtract(Duration(days: 280)),
                                                                      lastDay: DateTime.now(),
                                                                      focusedDay: controller.getFocusedDate,
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
                                                                      calendarFormat: CalendarFormat.month,
                                                                      markerBuilder: (context, day, events) {
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
                                                                        return SizedBox();
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  CustomButton(
                                                                    text: AppLocalizations.of(context)!.send,
                                                                    onPressed: () {
                                                                      controller.editPregnancyStartDate(context);
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
                                          "${formatDate(DateTime.parse(controller.currentlyPregnantData.value.tanggalPerkiraanLahir!))}",
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.bold(12, height: 1.5),
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
                                          AppLocalizations.of(context)!.trimester,
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.medium(11, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].trimester ?? ""}",
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.bold(12, height: 1.5),
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
                                          AppLocalizations.of(context)!.weekDue,
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.medium(11, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          "${controller.weeklyData[controller.currentPregnancyWeekIndex.value].mingguSisa ?? ""}W",
                                          textAlign: TextAlign.center,
                                          style: CustomTextStyle.bold(12, height: 1.5),
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
                                                AppLocalizations.of(context)!.babySize,
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
                                          'assets/image/${controller.weeklyData[(controller.getPregnancyIndex ?? 0)].ukuranBayiImgPath}',
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
                                                    text: AppLocalizations.of(context)!.idealWeight,
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
                                                    text: AppLocalizations.of(context)!.idealHeight,
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
                                    title: AppLocalizations.of(context)!.thisWeeksHighlight,
                                    imagePath: 'assets/icon/sticky-note.png',
                                    onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: AppLocalizations.of(context)!.highlight), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].poinUtama),
                                  ),
                                  SizedBox(width: 10),
                                  WeeklyInfo(
                                    title: AppLocalizations.of(context)!.bodyChangesThisWeek,
                                    imagePath: 'assets/icon/pregnant.png',
                                    onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: AppLocalizations.of(context)!.bodyChanges), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].perubahanTubuh),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  WeeklyInfo(
                                    title: AppLocalizations.of(context)!.yourBabyThisWeek,
                                    imagePath: 'assets/icon/pregnancy.png',
                                    onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: AppLocalizations.of(context)!.yourBabyDevelopment), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].perkembanganBayi),
                                  ),
                                  SizedBox(width: 10),
                                  WeeklyInfo(
                                    title: AppLocalizations.of(context)!.symptomsYouMightFeel,
                                    imagePath: 'assets/icon/morning-sickness.png',
                                    onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: AppLocalizations.of(context)!.symptoms), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].gejalaUmum),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  WeeklyInfo(
                                    title: AppLocalizations.of(context)!.thingsToConsider,
                                    imagePath: 'assets/icon/list.png',
                                    onTap: () => Get.to(() => DetailPregnancyView(appbarTitle: AppLocalizations.of(context)!.thingsToConsider), arguments: controller.weeklyData[(controller.getPregnancyIndex ?? 0) < 2 ? 2 : controller.getPregnancyIndex ?? 0].tipsMingguan),
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
                    ),
                  ),
                ),
              );
            }
          },
        ),
      )),
    );
  }

  Widget pregnancyRecovery(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.recoveryMode,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                if (controller.storageService.getIsBirthSuccess()) ...[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 255, 216, 216),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icon/newborn.png",
                          width: 100,
                        ),
                        Text(
                          AppLocalizations.of(context)!.babyBirthCongratsTitle,
                          style: CustomTextStyle.bold(20, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Text(
                          AppLocalizations.of(context)!.babyBirthCongratsDescription,
                          style: CustomTextStyle.regular(16, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromARGB(255, 255, 216, 216),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/icon/plant.png",
                          width: 100,
                        ),
                        Text(
                          AppLocalizations.of(context)!.babyBirthLossTitle,
                          style: CustomTextStyle.bold(20, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3),
                        Text(
                          AppLocalizations.of(context)!.babyBirthLossDescription,
                          style: CustomTextStyle.regular(16, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icon/menstruation.png",
                        width: 80,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.hasYourPeriodReturn,
                              style: CustomTextStyle.semiBold(16, height: 1.5),
                            ),
                            SizedBox(height: 10),
                            CustomButton(
                              text: AppLocalizations.of(context)!.recordYourPeriod,
                              onPressed: () => Get.to(() => ChangePurposeView()),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: Get.width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.contrast,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.commonlyAskedQuestion,
                    style: CustomTextStyle.bold(20, color: AppColors.white),
                  ),
                ),
                if (controller.storageService.getIsBirthSuccess()) ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.whatToExpectAfterBirth,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.whatToExpectAfterBirthDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("webmd.com/baby/first-period-after-pregnancy-what-to-expect"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.whenWillMyPeriodReturn,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.whenWillMyPeriodeReturnDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("webmd.com/baby/first-period-after-pregnancy-what-to-expect"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.canIStillGetPregnant,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.canIStillGetPregnantDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("webmd.com/baby/first-period-after-pregnancy-what-to-expect"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.howMyPeriodChangesAfterPregnancy,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.howMyPeriodChangesAfterPregnancyDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("webmd.com/baby/first-period-after-pregnancy-what-to-expect"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.recoveryAfterMiscarriage,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.recoveryAfterMiscarriageDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("www.webmd.com/baby/understanding-miscarriage-basics"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.whenToTryAgainAfterMiscarriage,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.whenToTryAgainAfterMiscarriageDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("www.webmd.com/baby/understanding-miscarriage-basics"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.recoveryAfterAbortion,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.recoveryAfterAbortionDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("www.webmd.com/women/abortion-self-care-after"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          shape: Border(),
                          title: Text(
                            AppLocalizations.of(context)!.whenWillPeriodStartAfterAbortion,
                            style: CustomTextStyle.bold(16, height: 1.5),
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.whenWillPeriodStartAfterAbortionDesc,
                                style: CustomTextStyle.medium(14, height: 1.75),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                AppLocalizations.of(context)!.sourceFrom("www.webmd.com/women/abortion-self-care-after"),
                                style: CustomTextStyle.regular(12, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
