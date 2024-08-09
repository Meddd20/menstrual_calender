import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';

class DetailPregnancyView extends GetView {
  final String appbarTitle;
  final String? bannerPicture;
  const DetailPregnancyView({Key? key, required this.appbarTitle, this.bannerPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pregnancyData = Get.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appbarTitle),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   width: Get.width,
              //   // height: 250,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.zero,
              //   ),
              //   child: Image.asset(
              //     bannerPicture ?? 'assets/image/bd48b2bc7befdf66265a70239c555886.png',
              //     fit: BoxFit.fitWidth,
              //   ),
              // ),
              // SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                child: HtmlWidget(
                  pregnancyData,
                  textStyle: TextStyle(
                    fontSize: 16,
                    height: 1.75,
                    fontWeight: FontWeight.w400,
                  ),
                  customWidgetBuilder: (element) {
                    if (element.localName == 'h2') {
                      return Text(
                        element.text,
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    if (element.localName == 'h3') {
                      return Text(
                        element.text,
                        style: TextStyle(
                          fontSize: 22,
                          height: 1.25,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
