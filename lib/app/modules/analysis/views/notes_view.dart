import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_date_look.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_tabbar.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/notes_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesView extends GetView<NotesController> {
  const NotesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(NotesController());
    final PageController _pageController = PageController();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              AppLocalizations.of(context)!.notes,
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
          child: Column(
            children: [
              if (controller.selectedDataTags != "pregnancy_notes")
                CustomTabBar(
                  controller: controller.tabController,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                    controller.updateTabBar(index);
                  },
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    controller.tabController.animateTo(index);
                    controller.updateTabBar(index);
                  },
                  children: [
                    _buildChart(context),
                    _buildChart(context),
                    _buildChart(context),
                    _buildChart(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              height: Get.height,
              child: Obx(() {
                if (controller.specificNotesData.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.notFoundDesc,
                      style: CustomTextStyle.medium(16, color: AppColors.black.withOpacity(0.6), height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.specificNotesData.length,
                    itemBuilder: (context, index) {
                      final MapEntry<String, dynamic> entry = controller.specificNotesData.entries.elementAt(index);

                      return CustomDateLook(entry: entry, type: "notes");
                    },
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
