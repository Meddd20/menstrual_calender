import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;

import 'package:periodnpregnancycalender/app/common/common.dart';

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
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HtmlWidget(
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
                    SizedBox(height: 30),
                    Divider(
                      height: 0.5,
                      thickness: 1.0,
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Text(
                        AppLocalizations.of(context)!.medicalDisclaimer,
                        style: CustomTextStyle.medium(12),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)!.medicalDisclaimerDesc,
                      style: CustomTextStyle.light(12, height: 1.5),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
