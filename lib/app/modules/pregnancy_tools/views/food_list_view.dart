import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/food_list_controller.dart';
import 'package:readmore/readmore.dart';

class FoodListView extends GetView<FoodListController> {
  const FoodListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(FoodListController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Pregnancy Food Guide',
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
              minExtent: 130.h,
              maxExtent: 130.h,
              child: Container(
                color: AppColors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (query) {
                            controller.searchFood(query);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search food...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Container(
                          width: Get.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 5.0,
                            children: controller.filterTags
                                .map(
                                  (tag) => Container(
                                    width: (Get.width - 60) / controller.filterTags.length,
                                    child: ChoiceChip(
                                      label: Center(
                                        child: Text(tag),
                                      ),
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
                                      showCheckmark: false,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = controller.filteredFoodList[index];
                    return Wrap(
                      children: [
                        Container(
                          width: Get.width,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        food.foodSafety == "Unsafe"
                                            ? Icons.cancel_outlined
                                            : food.foodSafety == "Caution"
                                                ? Icons.warning_amber_rounded
                                                : Icons.check_circle_outline,
                                        color: food.foodSafety == "Unsafe"
                                            ? Colors.red
                                            : food.foodSafety == "Caution"
                                                ? Colors.yellow
                                                : Colors.green,
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: Get.width,
                                              child: Text(
                                                controller.storageService == "id" ? food.foodId! : food.foodEn!,
                                                style: CustomTextStyle.semiBold(16, height: 1.5),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Visibility(
                                              visible: (controller.storageService == "id" ? food.descriptionId : food.descriptionEn) != null && (controller.storageService == "id" ? food.descriptionId : food.descriptionEn)!.isNotEmpty,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 10),
                                                child: ReadMoreText(
                                                  controller.storageService == "id" ? food.descriptionId ?? "" : food.descriptionEn ?? "",
                                                  trimLines: 4,
                                                  colorClickableText: Colors.blue,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: '...Read more',
                                                  trimExpandedText: ' Show less',
                                                  moreStyle: CustomTextStyle.bold(14, height: 1.75, color: Colors.blue),
                                                  lessStyle: CustomTextStyle.bold(14, height: 1.75, color: Colors.blue),
                                                  style: CustomTextStyle.regular(14, height: 1.75),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: controller.filteredFoodList.length,
                ),
              ),
            ),
          ),
        ],
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
