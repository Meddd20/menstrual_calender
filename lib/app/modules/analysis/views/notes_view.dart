import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/notes_controller.dart';

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
          title: const Text('Notes'),
          centerTitle: true,
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
                    _buildChart(),
                    _buildChart(),
                    _buildChart(),
                    _buildChart(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (controller.data == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: Get.height,
                child: Obx(() {
                  if (controller.specificNotesData.isEmpty) {
                    return Center(child: Text("No data available"));
                  } else {
                    return ListView.builder(
                      itemCount: controller.specificNotesData.length,
                      itemBuilder: (context, index) {
                        final MapEntry<String, dynamic> entry = controller
                            .specificNotesData.entries
                            .elementAt(index);

                        return CustomDateLook(entry: entry);
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
}
