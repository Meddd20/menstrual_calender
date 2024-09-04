import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

class ShettlesPredDetailView extends GetView {
  const ShettlesPredDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments as ShettlesGenderPrediction;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.shettlesPredictionMethod,
            style: CustomTextStyle.extraBold(22),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod1,
                  style: CustomTextStyle.extraBold(24),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.shettlesPredictionMethod2,
                        style: CustomTextStyle.regular(16, height: 1.75),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.shettlesPredictionMethod3("${formatDateToShortMonthDay(argument.boyStartDate.toString())}", "${formatDateToShortMonthDay(argument.boyEndDate.toString())}"),
                        style: CustomTextStyle.bold(16, height: 1.75),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.shettlesPredictionMethod4,
                        style: CustomTextStyle.regular(16, height: 1.75),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.shettlesPredictionMethod5("${formatDateToShortMonthDay(argument.girlStartDate.toString())}", "${formatDateToShortMonthDay(argument.girlEndDate.toString())}"),
                        style: CustomTextStyle.bold(16, height: 1.75),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod6,
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod7,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod8,
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod9,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod10,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod11,
                  style: CustomTextStyle.extraBold(24),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod12,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod13,
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod14,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod15,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod16,
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context)!.shettlesPredictionMethod17,
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 15),
                ExpansionTile(
                  title: Text(
                    AppLocalizations.of(context)!.references,
                    style: CustomTextStyle.bold(20),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text(
                        "• ​Blight, A. (2019). The Shettles method of sex selection. https://embryo.asu.edu/pages/shettles-method-sex-selection\n• Douching. (2019).https://www.womenshealth.gov/a-z-topics/douching#4\n• Rahman, S., et al. (2020). New biological insights on x and y chromosome-bearing spermatozoa.https://www.frontiersin.org/articles/10.3389/fcell.2019.00388/full#h6\n• Sex chromosome. (n.d.).https://www.genome.gov/genetics-glossary/Sex-Chromosome\n• Scarpa, B. (2016). Bayesian inference on predictors of sex of the baby.https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4877388/\n• Gray RH. (1991). Natural family planning and sex selection: Fact or fiction.https://www.ncbi.nlm.nih.gov/m/pubmed/1836712/\n• Hossain AM, et al. (2001). Lack of significant morphological differences between human x and y spermatozoa and their precursor cells (spermatids) exposed to different prehybridization treatments.https://pubmed.ncbi.nlm.nih.gov/11191075/\n• Fletcher, J. (2021, July 29). Shettles method: What is it, and does it work? Retrieved May 18, 2024, from Medicalnewstoday.com website: https://www.medicalnewstoday.com/articles/shettles-method#conceiving-a-male\n• Grunebaum, A. (2007, January 27). How to Conceive a Boy or Girl: The Shettles Method | babyMed.com. from babyMed.com website: https://www.babymed.com/getting-pregnant-conception-implantation/how-conceive-boy-or-girl-shettles-method",
                        style: CustomTextStyle.regular(16, height: 1.75),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
