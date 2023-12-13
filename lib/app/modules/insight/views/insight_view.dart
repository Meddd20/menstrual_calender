import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/model/article.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/detail_article_view.dart';
import 'package:periodnpregnancycalender/app/services/article_service.dart';
import '../controllers/insight_controller.dart';

class InsightView extends GetView<InsightController> {
  const InsightView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put<InsightController>(InsightController());
    final List<Article> articles = ArticleService.getArticles();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InsightView'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Column(
            children: [
              Obx(
                () => Container(
                  width: Get.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 10.0,
                      children: controller.filterTags
                          .map(
                            (tag) => ChoiceChip(
                              label: Text(tag),
                              selected: controller.getSelectedTag() == tag,
                              onSelected: (bool isSelected) {
                                if (isSelected) {
                                  controller.setSelectedTag(tag);
                                } else {
                                  controller.setSelectedTag("");
                                }
                              },
                              labelStyle: TextStyle(
                                color: controller.getSelectedTag() == tag
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                              backgroundColor: Colors.transparent,
                              selectedColor: Color(0xFF34C2C1),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => DetailArticleView(article: article));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width,
                                  height: 136,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://via.placeholder.com/290x136"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  article.titleInd,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  article.contentInd,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 10.h),
                                IntrinsicWidth(
                                  child: Container(
                                    height: 30.h,
                                    decoration: ShapeDecoration(
                                      color: Color(0x7F88E6BF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Center(
                                        child: Text(
                                          article.tags,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
