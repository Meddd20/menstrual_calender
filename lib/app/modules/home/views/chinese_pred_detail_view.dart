import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/models/date_event_model.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChinesePredDetailView extends GetView {
  const ChinesePredDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments as ChineseGenderPrediction;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.chineseGenderPredction,
            style: CustomTextStyle.extraBold(22),
          ),
        ),
        centerTitle: true,
        backgroundColor: argument.genderPrediction == "f" ? Color.fromARGB(255, 253, 225, 248) : Color(0xFF2196F3),
        surfaceTintColor: AppColors.white,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          color: argument.genderPrediction == "f" ? Color.fromARGB(255, 253, 225, 248) : Color(0xFF2196F3),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      AppLocalizations.of(context)!.chineseGenderPredction1,
                      style: CustomTextStyle.extraBold(24, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          '${argument.genderPrediction == 'f' ? 'assets/image/baby-girl.svg' : 'assets/image/baby-boy.svg'}',
                          height: 140,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        "${argument.genderPrediction == 'f' ? "${AppLocalizations.of(context)!.girl}" : "${AppLocalizations.of(context)!.boy}"}",
                        style: CustomTextStyle.extraBold(30),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.mothersAge,
                                  style: CustomTextStyle.medium(15, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Text(
                              "${argument.age}",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.mothersLunarAge,
                                  style: CustomTextStyle.medium(15, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Text(
                              "${argument.lunarAge}",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                AppLocalizations.of(context)!.mothersBirthdayAge,
                                style: CustomTextStyle.medium(15, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              argument.dateOfBirth != null ? formatDateStrWithMonthName(argument.dateOfBirth!) : "N/A",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                AppLocalizations.of(context)!.mothersBirthdayLunarAge,
                                style: CustomTextStyle.medium(15, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              argument.lunarDateOfBirth != null ? formatDateStrWithMonthName(argument.lunarDateOfBirth!) : "N/A",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                AppLocalizations.of(context)!.babyConceivedDate,
                                style: CustomTextStyle.medium(15, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              argument.specifiedDate != null ? formatDateStrWithMonthName(argument.specifiedDate!) : "N/A",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                AppLocalizations.of(context)!.babyConceivedLunarDate,
                                style: CustomTextStyle.medium(15, height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              argument.lunarSpecifiedDate != null ? formatDateStrWithMonthName(argument.lunarSpecifiedDate!) : "N/A",
                              style: CustomTextStyle.extraBold(20, height: 2.0),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(),
                    SizedBox(height: 25),
                    Text(
                      AppLocalizations.of(context)!.chineseGenderPredction2,
                      style: CustomTextStyle.extraBold(24),
                    ),
                    SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!.chineseGenderPredction3,
                      style: CustomTextStyle.regular(16, height: 1.75),
                    ),
                    SizedBox(height: 15),
                    ExpansionTile(
                      shape: Border(),
                      title: Text(
                        AppLocalizations.of(context)!.references,
                        style: CustomTextStyle.bold(20),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            "• Chinese lunar calendar: Don’t paint the nursery just yet. (2010, May 25). Retrieved from University of Michigan News. website: https://news.umich.edu/chinese-lunar-calendar-don-t-paint-the-nursery-just-yet/\n• Katz, D., & Wylie, B. (2009). 568: The Chinese birth calendar for prediction of gender - fact or fiction? American Journal of Obstetrics and Gynecology, 201(6), S211–S211. https://doi.org/10.1016/j.ajog.2009.10.433",
                            style: CustomTextStyle.regular(16, height: 1.75),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: Get.width,
                      height: 560.0,
                      child: PhotoView(
                        imageProvider: AssetImage('assets/image/chinese chart.jpg'),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 2,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
