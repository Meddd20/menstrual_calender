import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/vaccine_list_controller.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VaccineListView extends GetView<VaccineListController> {
  const VaccineListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(VaccineListController());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                AppLocalizations.of(context)!.pregnancyVaccineGuide,
                style: CustomTextStyle.extraBold(22),
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            elevation: 4,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(28.w, 0.h, 20.w, 0),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.pregnancyVaccineGuideDesc,
                    style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: controller.listVaccines,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!snapshot.hasData) {
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
                        final vaccine = snapshot.data![index];
                        return Wrap(
                          children: [
                            Container(
                              width: Get.width,
                              padding: EdgeInsets.only(bottom: 10),
                              child: Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 25,
                                  ),
                                  title: Text(
                                    controller.storageService.getLanguage() == "id" ? vaccine.vaccinesId! : vaccine.vaccinesEn!,
                                    style: CustomTextStyle.bold(16, height: 1.5),
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: ReadMoreText(
                                      controller.storageService.getLanguage() == "id" ? vaccine.descriptionId! : vaccine.descriptionEn!,
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
                            ),
                          ],
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
