import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:html/parser.dart' as html_parser;

class DetailPregnancyView extends GetView {
  final String appbarTitle;
  final String? bannerPicture;
  const DetailPregnancyView({Key? key, required this.appbarTitle, this.bannerPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pregnancyData = Get.arguments as String;
    final document = html_parser.parse(pregnancyData);
    final h2Element = document.querySelector('h2');
    final extractedTitle = h2Element != null ? h2Element.text : appbarTitle;

    document.querySelectorAll('h2').forEach((element) => element.remove());
    final filteredHtml = document.outerHtml;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text(
                extractedTitle,
                style: CustomTextStyle.extraBold(20, height: 1.5),
              ),
              titleSpacing: 0,
              centerTitle: true,
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              elevation: 4,
              stretchTriggerOffset: 50,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                    child: HtmlWidget(
                      filteredHtml,
                      textStyle: CustomTextStyle.medium(16, height: 1.75),
                      customWidgetBuilder: (element) {
                        if (element.localName == 'h3') {
                          return Text(
                            element.text,
                            style: CustomTextStyle.extraBold(22, height: 1.25),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
