import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/vitamin_list_controller.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VitaminListView extends GetView<VitaminListController> {
  const VitaminListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(VitaminListController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                AppLocalizations.of(context)!.pregnancyVitaminGuide,
                style: CustomTextStyle.extraBold(22),
              ),
            ),
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            elevation: 4,
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(28.w, 0.h, 20.w, 0),
              child: Container(
                width: Get.width,
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.pregnancyVitaminGuideDesc,
                      style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: controller.listVitamins,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.notFoundDesc,
                      style: CustomTextStyle.medium(16, color: AppColors.black.withOpacity(0.6), height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final vitamin = snapshot.data![index];
                        return Container(
                          width: Get.width,
                          padding: EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 25,
                              ),
                              title: Text(
                                controller.storageService.getLanguage() == "id" ? vitamin.vitaminsId! : vitamin.vitaminsEn!,
                                style: CustomTextStyle.bold(16, height: 1.5),
                              ),
                              subtitle: Container(
                                padding: EdgeInsets.only(top: 10),
                                child: ReadMoreText(
                                  controller.storageService.getLanguage() == "id" ? vitamin.descriptionId! : vitamin.descriptionEn!,
                                  trimLines: 4,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: AppLocalizations.of(context)!.readMore,
                                  trimExpandedText: AppLocalizations.of(context)!.showLess,
                                  moreStyle: CustomTextStyle.bold(14, height: 1.75, color: Colors.blue),
                                  lessStyle: CustomTextStyle.bold(14, height: 1.75, color: Colors.blue),
                                  style: CustomTextStyle.regular(14, height: 1.75),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: snapshot.data!.length,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
