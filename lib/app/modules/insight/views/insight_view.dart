import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/insight/views/insight_detail_view.dart';
import 'package:periodnpregnancycalender/app/utils/api_endpoints.dart';
import '../controllers/insight_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsightView extends GetView<InsightController> {
  const InsightView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(InsightController());
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchArticles(null);
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    AppLocalizations.of(context)!.insight,
                    style: CustomTextStyle.extraBold(22),
                  ),
                ),
                centerTitle: true,
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                elevation: 4,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverPersistentHeaderDelegate(
                  maxExtent: 60.0,
                  minExtent: 60.0,
                  child: Container(
                    color: AppColors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                      child: Obx(
                        () => Container(
                          height: 60,
                          width: Get.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              spacing: 10.0,
                              children: controller.filterTags.map(
                                (tag) {
                                  final tagTranslations = controller.getTagTranslations(context);
                                  return ChoiceChip(
                                    label: Text(tagTranslations[tag] ?? tag),
                                    selected: controller.getSelectedTag() == tag,
                                    onSelected: (bool isSelected) {
                                      if (isSelected) {
                                        controller.setSelectedTag(tag);
                                      } else {
                                        controller.setSelectedTag("");
                                      }
                                    },
                                    labelStyle: CustomTextStyle.semiBold(14, color: controller.getSelectedTag() == tag ? AppColors.white : AppColors.black),
                                    backgroundColor: AppColors.transparent,
                                    selectedColor: AppColors.contrast,
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () {
                  if (controller.isLoading.value) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, Get.width / 2, 20.w, 0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else if (controller.articles.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 100.h, 20.w, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/no-data.png',
                              width: 200.w,
                              height: 200.h,
                            ),
                            SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context)!.notFound,
                              style: CustomTextStyle.extraBold(20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.notFoundDesc,
                              style: CustomTextStyle.medium(16, color: AppColors.black.withOpacity(0.6), height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SliverPadding(
                      padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final article = controller.articles[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    int? articleId = article.id;
                                    Get.to(() => InsightDetailView(), arguments: articleId);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      color: AppColors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Get.width,
                                          height: 136,
                                          decoration: ShapeDecoration(
                                            image: DecorationImage(
                                              image: article.banner != null ? NetworkImage("${ApiEndPoints.baseUrl}/${article.banner}") : AssetImage("assets/image/no-image.png") as ImageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          controller.storageService.getLanguage() == "en" ? article.titleEng ?? "" : article.titleInd ?? "",
                                          style: CustomTextStyle.extraBold(18, height: 1.5),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          controller.storageService.getLanguage() == "en" ? article.contentEng ?? "" : article.contentInd ?? "",
                                          style: CustomTextStyle.regular(14, height: 1.5),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 10.h),
                                        IntrinsicWidth(
                                          child: Container(
                                            height: 30.h,
                                            decoration: ShapeDecoration(
                                              color: Color.fromARGB(126, 186, 255, 226),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Center(
                                                child: Text(
                                                  controller.getTagTranslations(context)[article.tags] ?? article.tags ?? "",
                                                  style: CustomTextStyle.bold(12),
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
                          childCount: controller.articles.length,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtent;
  final double maxExtent;
  final Widget child;

  _SliverPersistentHeaderDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent || child != oldDelegate.child;
  }
}
