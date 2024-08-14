import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/models/period_cycle_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';

class ShettlesPredDetailView extends GetView {
  const ShettlesPredDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeMenstruationController homeController = Get.put(HomeMenstruationController());
    final argument = Get.arguments as ShettlesGenderPrediction;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "The Shettles Prediction Method",
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
                  "Based on the Shettles Method",
                  style: CustomTextStyle.extraBold(24),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Aim for intercourse on ovulation day and the next 2-3 days ',
                        style: CustomTextStyle.regular(16, height: 1.75),
                      ),
                      TextSpan(
                        text: 'from ${homeController.formatDate(argument.boyStartDate.toString())} until ${homeController.formatDate(argument.boyEndDate.toString())} to likely conceive a male',
                        style: CustomTextStyle.bold(16, height: 1.75),
                      ),
                      TextSpan(
                        text: ', and have intercourse from the end of menstruation until three days before ovulation, avoiding sex 2-3 days before ovulation ',
                        style: CustomTextStyle.regular(16, height: 1.75),
                      ),
                      TextSpan(
                        text: 'from ${homeController.formatDate(argument.girlStartDate.toString())} until ${homeController.formatDate(argument.girlEndDate.toString())} to likely conceive a female.',
                        style: CustomTextStyle.bold(16, height: 1.75),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "What is The Shettles Method?",
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  "In the 1960s, Dr. Landrum Shettles began studying sperm to understand how they influence the sex of a fetus. He suggested that sperm differ based on whether they carry an X or Y chromosome. The Shettles method is based on the idea that these differences between male (Y) and female (X) sperm can be used to influence the sex of the fetus.\n\nThis method recommends specific times for intercourse, preferred sexual positions, and adjustments to the pH of bodily fluids to favor either X or Y sperm reaching the egg first, thereby theoretically determining the sex of the fetus.\n\nDr. Shettles identified key differences between male and female sperm. Male sperm, which carry Y chromosomes, are small with rounded heads, swim faster, and thrive in the alkaline conditions near the cervix. Female sperm, which carry X chromosomes, are larger with oval-shaped heads, swim slower, and survive longer in the acidic conditions of the vagina.\n\nDr. Shettles claimed these differences influenced how quickly sperm could reach the egg and their ability to survive in the vaginal environment. He noted that cervical secretions become more alkaline closer to ovulation, making timing of intercourse critical depending on the desired sex of the fetus.",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  "How the method suggests conceiving a female?",
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  "According to the Shettles method, the following factors are recommended to conceive a female fetus:",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                Text(
                  "• Sexual Position: Engage in face-to-face intercourse with shallow penetration. This allows sperm to pass through the acidic environment of the vagina, which is believed to favor female sperm.\n• Timing of Intercourse: Have sexual intercourse between the end of menstruation and three days before ovulation, then abstain from intercourse 2–3 days before ovulation.\n• Timing of Female Orgasm: Since the secretions from female orgasm are alkaline, Dr. Shettles recommended that the female should avoid orgasming until after the male has ejaculated.\n• Douching: Use a douche made from 2 tablespoons of white vinegar mixed with 1 quart of water to create a more acidic environment.",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  "Douching and Safety",
                  style: CustomTextStyle.extraBold(24),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15),
                Text(
                  "It's important to note that vaginal douching is not considered safe. The Office on Women’s Health highlights that douching can cause various health issues and may be linked to difficulties in getting pregnant, ectopic pregnancies, and preterm labor.\n\nDouching can also increase the risk of vaginal infections, such as yeast infections and bacterial vaginosis. Furthermore, if a person has a vaginal infection, douching can push bacteria into the uterus, ovaries, and fallopian tubes, potentially leading to pelvic inflammatory disease.",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  "How the Method Suggests Conceiving a Male?",
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  "According to the Shettles method, the following factors are recommended to conceive a male fetus:",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                Text(
                  "• Sexual Position: Engage in rear-entry intercourse to achieve deep penetration, depositing sperm closer to the cervix.\n• Timing of Intercourse: Refrain from sexual intercourse from the beginning of the menstrual cycle until the day of ovulation. Have intercourse on the day of ovulation and the following three days.\n• Timing of Female Orgasm: The female should orgasm before the male ejaculates to increase alkaline secretions favorable to male sperm.\n• Douching: Use a douche made from 2 tablespoons of baking soda mixed with 1 quart of water to create an alkaline environment.",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 25),
                Text(
                  "Does It Really Work?",
                  style: CustomTextStyle.extraBold(24),
                ),
                SizedBox(height: 15),
                Text(
                  "Dr. Shettles claimed that his methodology had an 80% success rate among his patients, but he acknowledged that the method does not guarantee the desired outcome.\n\nBlogger Genevieve Howland of Mama Natural reports that the Shettles method helped her conceive a girl with her second pregnancy by timing intercourse three days before ovulation, which resulted in a girl. She also notes that having intercourse on the day of ovulation with her first pregnancy resulted in a boy.\n\nHowever, not all researchers agree with Shettles' claims. A 1991 review of studies found no support for the idea that timing intercourse affects the sex of the baby. This review noted that fewer male babies were conceived during peak ovulation, with more male babies conceived three to four days before or two to three days after ovulation.\n\nA 2001 study refuted Shettles' assertion that X- and Y-containing sperm have different shapes, directly contradicting his research. Additionally, a 1995 study indicated that having sex two to three days after ovulation does not necessarily lead to pregnancy.\n\nThe science remains unclear. Currently, the only guaranteed method to select a baby's sex is through preimplantation genetic diagnosis (PGD), a procedure sometimes used in conjunction with in vitro fertilization (IVF).\n\nA 2016 study indicates that there is no evidence to support the idea that the timing or pattern of intercourse influences the sex of the fetus. Similarly, a 2020 study found that there are no significant differences between male and female sperm that would impact their behavior in a way that supports the Shettles method.",
                  style: CustomTextStyle.regular(16, height: 1.75),
                ),
                SizedBox(height: 15),
                ExpansionTile(
                  title: Text(
                    "References",
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
