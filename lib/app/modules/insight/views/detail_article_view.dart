import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/models/article_model.dart';
import 'package:periodnpregnancycalender/app/modules/insight/controllers/insight_controller.dart';

class DetailArticleView extends GetView<InsightController> {
  final Articles article;
  const DetailArticleView({Key? key, required this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime? createdAt =
        article.createdAt != null ? DateTime.parse(article.createdAt!) : null;

    String formattedDate = createdAt != null
        ? DateFormat('EEEE, d MMMM yyyy HH:mm \'WITA\'').format(createdAt)
        : "";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Artikel'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      article.titleInd ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    article.writter ?? "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.38,
                      height: 2.0,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.38,
                      height: 2.0,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: Get.width,
                    height: 180,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage("${article.banner}"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    article.contentInd ?? "",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.38,
                      height: 2.0,
                    ),
                  ),
                  Container(
                    width: Get.width,
                    child: Text(
                      "References",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.38,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    width: Get.width,
                    child: Text(
                      article.source ?? "",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.38,
                        height: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
