import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_detail_view.dart';
import '../controllers/insight_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';

class InsightView extends GetView<InsightController> {
  const InsightView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(InsightController());
    ;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InsightView'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 1400));
            await controller.articlesFuture;
          },
          child: FutureBuilder(
            future: controller.articlesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
                // } else if (!snapshot.hasData) {
                //   return Center(child: Text('No data available'));
              } else {
                return Padding(
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
                                      selected:
                                          controller.getSelectedTag() == tag,
                                      onSelected: (bool isSelected) {
                                        print(
                                            "Tag selected: $tag, isSelected: $isSelected");
                                        if (isSelected) {
                                          controller.setSelectedTag(tag);
                                        } else {
                                          controller.setSelectedTag("");
                                        }
                                      },
                                      labelStyle: TextStyle(
                                        color:
                                            controller.getSelectedTag() == tag
                                                ? AppColors.white
                                                : AppColors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      backgroundColor: AppColors.transparent,
                                      selectedColor: AppColors.contrast,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () {
                            if (controller.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Obx(
                                () => ListView.builder(
                                  itemCount: controller.articles.length,
                                  itemBuilder: (context, index) {
                                    final article = controller.articles[index];
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            String? articleId = article.id;
                                            Get.to(() => InsightDetailView(),
                                                arguments: articleId);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              color: AppColors.white,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width,
                                                  height: 136,
                                                  decoration: ShapeDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${article.banner}"),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  article.titleInd ?? "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.sp,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 5.h),
                                                Text(
                                                  article.contentInd ?? "",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 10.h),
                                                IntrinsicWidth(
                                                  child: Container(
                                                    height: 30.h,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0x7F88E6BF),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      child: Center(
                                                        child: Text(
                                                          article.tags ?? "",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                        SizedBox(height: 10)
                                      ],
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
