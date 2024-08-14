import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/models/date_event_model.dart';
import 'package:periodnpregnancycalender/app/modules/home/controllers/home_menstruation_controller.dart';
import 'package:photo_view/photo_view.dart';

class ChinesePredDetailView extends GetView {
  const ChinesePredDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    HomeMenstruationController homeController = Get.put(HomeMenstruationController());
    final argument = Get.arguments as ChineseGenderPrediction;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Chinese Gender Predictions",
            style: CustomTextStyle.extraBold(22),
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 4,
      ),
      body: Container(
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
                    "Your baby gender is predicted to be..",
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
                      "${argument.genderPrediction == 'f' ? 'Girl' : 'Boy'}",
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
                                "Mother's Age",
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
                                "Mother's Lunar Age",
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
                              "Mother's Birthday in Western Date",
                              style: CustomTextStyle.medium(15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "${homeController.formatDate1(argument.dateOfBirth)}",
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
                              "Mother's Birthday in Lunar Date",
                              style: CustomTextStyle.medium(15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "${homeController.formatDate1(argument.lunarDateOfBirth)}",
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
                              "Baby Conceived in Western Date",
                              style: CustomTextStyle.medium(15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "${homeController.formatDate1(argument.specifiedDate)}",
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
                              "Baby Conceived in Lunar Date",
                              style: CustomTextStyle.medium(15, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "${homeController.formatDate1(argument.lunarSpecifiedDate)}",
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
                    "What is Chinese Gender Predictor Chart?",
                    style: CustomTextStyle.extraBold(24),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "To use it, you first have to find the mother's lunar age at conception, which is different from her age in the Western calendar. Then, you locate the month of conception on the chart. By intersecting these two points, the chart suggests the baby's gender.\n\nHowever, its accuracy is a matter of debate. Some view its effectiveness as rooted more in cultural belief than empirical evidence. Nevertheless, many expectant parents worldwide still enjoy using it, adding a touch of mystery to the excitement of awaiting their baby's arrival.\n\nThe widely believed story is that the Chinese Gender Calendar Chart was made during the Qing Dynasty (1644-1911 A.D.). It's said to be inspired by the ancient text \"Book of Changes,\" which talks about the Five Elements (Metal, Water, Wood, Fire, and Earth), Yin and Yang, and the Eight Trigrams. Legend has it that the imperial family of the Qing Dynasty used this chart to choose the gender of their children. It was a closely guarded secret within the palace and wasn't shared with the public.\n\nThe Chinese Gender Predictor Chart has two popular stories about its origins. One tale claims it was created during the Qing Dynasty and used by the imperial family to choose the gender of their children. It was kept secret until the end of the dynasty when it was taken during the Boxer Rebellion and ended up in England and Austria before being published in Taiwan in 1972. Another story suggests it was found buried in a royal tomb over 700 years ago near Beijing.\n\nDespite these interesting stories, there's no scientific proof that the chart works. It's more of a cultural tradition, used for fun rather than as a reliable way to predict a baby's gender.\n\nAfter reviewing over 38,000 delivery records at Massachusetts General Hospital from 1995 to 2008, it was found that the claimed accuracy of the Chinese birth calendar in predicting infant gender (93-99%) is greatly exaggerated. Both the Gregorian and Chinese lunar calendars only accurately predicted gender about 50% of the time, no better accuracy than a coin toss. Similarly, a study led by Dr. Eduardo Villamor from the University of Michigan, examining 2.8 million Swedish births from 1973 to 2006, concluded that the Chinese lunar calendar method is no better than guessing and lacks scientific validity, despite claims of high accuracy on some websites.",
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
    );
  }
}
