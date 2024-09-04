import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/home_menstruation_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                floating: true,
                title: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    AppLocalizations.of(context)!.menstruationMode,
                    style: CustomTextStyle.extraBold(22),
                  ),
                ),
                centerTitle: true,
                snap: false,
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TableCalendar(
                                focusedDay: controller.getFocusedDate,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                availableCalendarFormats: {
                                  CalendarFormat.month: AppLocalizations.of(context)!.month,
                                  CalendarFormat.week: AppLocalizations.of(context)!.week,
                                },
                                calendarFormat: controller.getFormat,
                                onFormatChanged: (newFormat) {
                                  controller.setFormat(newFormat);
                                },
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                locale: controller.storageService.getLanguage() == "en" ? 'en_US' : 'id_ID',
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
                                  formatButtonShowsNext: true,
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
                                              style: CustomTextStyle.bold(16, color: Colors.white),
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
                                              style: CustomTextStyle.bold(16, color: Colors.white),
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
                                              style: CustomTextStyle.bold(16, color: Colors.white),
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
                                                style: CustomTextStyle.bold(16),
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
                                                style: CustomTextStyle.bold(16),
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
                                                style: CustomTextStyle.bold(16),
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
                                          style: CustomTextStyle.bold(16),
                                        ),
                                      ),
                                    );
                                  },
                                  dowBuilder: (context, day) {
                                    return Center(
                                      child: Text(
                                        DateFormat.E().format(day),
                                        style: CustomTextStyle.regular(14),
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
                                          style: CustomTextStyle.bold(16, color: Colors.white),
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
                                          style: CustomTextStyle.bold(16, color: Colors.white),
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
                                            style: CustomTextStyle.extraBold(18),
                                          )),
                                      Obx(
                                        () => Text(
                                          "${formatMonthDayYear(controller.selectedDate!.toString())}",
                                          style: CustomTextStyle.medium(15),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 35.h),
                                  Text(
                                    AppLocalizations.of(context)!.currentCycle,
                                    style: CustomTextStyle.medium(14, height: 1.5),
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                    width: Get.width,
                                    child: Obx(() => Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${controller.eventDatas.value.cycleDay ?? 'null'}",
                                                style: CustomTextStyle.bold(24),
                                              ),
                                              WidgetSpan(
                                                child: Transform.translate(
                                                  offset: const Offset(0, -8),
                                                  child: Text(
                                                    controller.getOrdinalSuffix(controller.eventDatas.value.cycleDay ?? 0),
                                                    style: CustomTextStyle.bold(14),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: AppLocalizations.of(context)!.dayOfTheCycle,
                                                style: CustomTextStyle.medium(20),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20.h),
                                  Obx(
                                    () => Text(
                                      AppLocalizations.of(context)!.pregnancyChances("${controller.eventDatas.value.pregnancyChances}"),
                                      style: CustomTextStyle.bold(16, height: 1.75),
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
                                      daysLeft: AppLocalizations.of(context)!.daysLeft('${controller.eventDatas.value.daysUntilNextMenstruation}'),
                                      predictionType: AppLocalizations.of(context)!.period,
                                      datePrediction: "${formatDateToShortMonthDay(controller.eventDatas.value.nextMenstruationStart ?? "")} - ${formatDateToShortMonthDay(controller.eventDatas.value.nextMenstruationEnd ?? "")}",
                                      iconPath: 'assets/icon/blood.png',
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0xFFFFE69E),
                                      primaryColor: Color(0xFFFD9414),
                                      daysLeft: AppLocalizations.of(context)!.daysLeft('${controller.eventDatas.value.daysUntilNextFertile}'),
                                      predictionType: AppLocalizations.of(context)!.fertileDays,
                                      datePrediction: '${formatDateToShortMonthDay(controller.eventDatas.value.nextFertileStart ?? "")} - ${formatDateToShortMonthDay(controller.eventDatas.value.nextFertileEnd ?? "")}',
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
                                      daysLeft: AppLocalizations.of(context)!.daysLeft('${controller.eventDatas.value.daysUntilNextOvulation}'),
                                      predictionType: AppLocalizations.of(context)!.ovulation,
                                      datePrediction: '${formatDateToShortMonthDay(controller.eventDatas.value.nextOvulation ?? "")}',
                                      iconPath: 'assets/icon/ovulation.png',
                                    ),
                                  ),
                                  SizedBox(width: 10.h),
                                  Obx(
                                    () => CustomCardPrediction(
                                      containerColor: Color(0xFFC6FCE5),
                                      primaryColor: Color.fromARGB(255, 111, 200, 161),
                                      daysLeft: AppLocalizations.of(context)!.daysLeft('${controller.eventDatas.value.daysUntilNextLuteal}'),
                                      predictionType: AppLocalizations.of(context)!.safeDays,
                                      datePrediction: '${formatDateToShortMonthDay(controller.eventDatas.value.nextLutealStart ?? "")} - ${formatDateToShortMonthDay(controller.eventDatas.value.nextLutealEnd ?? "")}',
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
                            height: 205.h,
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
                                        AppLocalizations.of(context)!.myCycle,
                                        style: CustomTextStyle.extraBold(18),
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.seeMore,
                                              style: CustomTextStyle.medium(14, color: Colors.black.withOpacity(0.6)),
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
                                    AppLocalizations.of(context)!.periodCycleLogged("${controller.data?.actualPeriod.length}"),
                                    style: CustomTextStyle.medium(14, height: 2.0, color: Colors.black.withOpacity(0.6)),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 110.h,
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
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!.averageCycleLength,
                                                    style: CustomTextStyle.extraBold(15, color: AppColors.primary),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 5),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${controller.data?.avgPeriodCycle}",
                                                          style: CustomTextStyle.extraBold(23),
                                                        ),
                                                        TextSpan(
                                                          text: AppLocalizations.of(context)!.daysPrefix,
                                                          style: CustomTextStyle.semiBold(14),
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
                                            height: 110.h,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFD9414),
                                                width: 0.5,
                                              ),
                                              color: Color(0xFFFFE69E),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!.averagePeriodLength,
                                                    style: CustomTextStyle.extraBold(15, color: Color(0xFFFD9414)),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${controller.data?.avgPeriodDuration}",
                                                          style: CustomTextStyle.extraBold(23),
                                                        ),
                                                        TextSpan(
                                                          text: AppLocalizations.of(context)!.daysPrefix,
                                                          style: CustomTextStyle.semiBold(14),
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
                                    height: 350.h,
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
                                                AppLocalizations.of(context)!.manageYourPeriodEvents,
                                                style: CustomTextStyle.extraBold(16, height: 1.5),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                AppLocalizations.of(context)!.trackYourPeriodCycle,
                                                style: CustomTextStyle.medium(13, height: 1.5),
                                              ),
                                              SizedBox(height: 10),
                                              CustomButton(
                                                text: AppLocalizations.of(context)!.reminder,
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
                                    height: 350.h,
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
                                                AppLocalizations.of(context)!.remarkYourBodyChanges,
                                                style: CustomTextStyle.extraBold(16, height: 1.5),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                AppLocalizations.of(context)!.logYourBodyChanges,
                                                style: CustomTextStyle.medium(13, height: 1.5),
                                              ),
                                              SizedBox(height: 32),
                                              CustomButton(
                                                text: AppLocalizations.of(context)!.dailyLog,
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
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xFF97B3E4),
                                ),
                                child: Wrap(
                                  children: [
                                    Padding(
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
                                                "${controller.eventDatas.value.chineseGenderPrediction?.genderPrediction == 'f' ? AppLocalizations.of(context)!.girl : AppLocalizations.of(context)!.boy}",
                                                style: CustomTextStyle.bold(18, height: 1.5),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width,
                                                  child: Text(
                                                    AppLocalizations.of(context)!.chineseGenderCalendar,
                                                    style: CustomTextStyle.extraBold(16, height: 1.75, color: AppColors.black.withOpacity(0.4)),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width,
                                                  child: Text(
                                                    AppLocalizations.of(context)!.didYouKnow,
                                                    style: CustomTextStyle.extraBold(26, height: 1.75),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Divider(
                                                  thickness: 1,
                                                  height: 1.0,
                                                  color: AppColors.white,
                                                ),
                                                SizedBox(height: 5),
                                                RichText(
                                                  text: TextSpan(
                                                    style: CustomTextStyle.medium(15, height: 1.5),
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.accordingTo,
                                                        style: CustomTextStyle.medium(15, height: 1.5),
                                                      ),
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.ancientChineseGenderChart,
                                                        style: CustomTextStyle.extraBold(16, height: 1.5),
                                                      ),
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.genderPrediction,
                                                        style: CustomTextStyle.medium(15, height: 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                                SizedBox(height: 15),
                                                CustomButton(
                                                  text: AppLocalizations.of(context)!.learnMore,
                                                  textColor: AppColors.white,
                                                  backgroundColor: AppColors.primary,
                                                  onPressed: () => Get.to(() => ChinesePredDetailView(), arguments: controller.eventDatas.value.chineseGenderPrediction),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Obx(
                            () => Visibility(
                              visible: controller.eventDatas.value.shettlesGenderPrediction != null,
                              child: Wrap(
                                children: [
                                  Container(
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
                                            AppLocalizations.of(context)!.theShettlesMethod,
                                            style: CustomTextStyle.extraBold(16, height: 1.75, color: AppColors.black.withOpacity(0.4)),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.increaseGenderPredictionProbability,
                                            style: CustomTextStyle.extraBold(22, height: 1.5),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(height: 5),
                                          Divider(
                                            thickness: 1,
                                            height: 1.0,
                                            color: AppColors.white,
                                          ),
                                          SizedBox(height: 5),
                                          Obx(() {
                                            return Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.aimForIntercourse,
                                                    style: CustomTextStyle.medium(15, height: 1.5),
                                                  ),
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.likelyConceiveMale('${formatDateToShortMonthDay(controller.eventDatas.value.shettlesGenderPrediction?.boyStartDate.toString() ?? "")}', '${formatDateToShortMonthDay(controller.eventDatas.value.shettlesGenderPrediction?.boyEndDate.toString() ?? "")}'),
                                                    style: CustomTextStyle.extraBold(16, height: 1.5),
                                                  ),
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.likelyConceiveFemale,
                                                  ),
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.femalePrediction('${formatDateToShortMonthDay(controller.eventDatas.value.shettlesGenderPrediction?.girlStartDate.toString() ?? "")}', '${formatDateToShortMonthDay(controller.eventDatas.value.shettlesGenderPrediction?.girlEndDate.toString() ?? "")}'),
                                                    style: CustomTextStyle.extraBold(16, height: 1.5),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          SizedBox(height: 15),
                                          CustomButton(
                                            text: AppLocalizations.of(context)!.learnMore,
                                            textColor: AppColors.white,
                                            backgroundColor: AppColors.primary,
                                            onPressed: () => Get.to(() => ShettlesPredDetailView(), arguments: controller.eventDatas.value.shettlesGenderPrediction),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
              label: AppLocalizations.of(context)!.addPeriod,
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
                            title: AppLocalizations.of(context)!.addPeriodCycle,
                            buttonCaption: AppLocalizations.of(context)!.addPeriod,
                            startDate: Obx(
                              () => Text(
                                "${formatDate(controller.startDate.value ?? DateTime.now())}",
                                style: CustomTextStyle.extraBold(15, height: 1.5),
                              ),
                            ),
                            endDate: Obx(
                              () => Text(
                                "${formatDate(controller.endDate.value ?? DateTime.now())}",
                                style: CustomTextStyle.extraBold(15, height: 1.5),
                              ),
                            ),
                            addPeriodOnPressedButton: () async {
                              controller.addPeriod(context, controller.data?.avgPeriodDuration ?? 7, controller.data?.avgPeriodCycle ?? 28);
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
              label: AppLocalizations.of(context)!.editPeriod,
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                Get.off(() => PeriodCycleView());
              },
            ),
            SpeedDialChild(
              child: Icon(Iconsax.note),
              label: AppLocalizations.of(context)!.dailyLog,
              shape: CircleBorder(side: BorderSide(color: Colors.white)),
              onTap: () {
                Get.to(() => DailyLogView());
              },
            ),
            SpeedDialChild(
              child: Icon(Iconsax.clock),
              label: AppLocalizations.of(context)!.reminder,
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
