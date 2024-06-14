import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/modules/analysis/controllers/others_controller.dart';

class OthersView extends GetView<OthersController> {
  const OthersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OthersController());
    final PageController _pageController = PageController();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Others'),
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
    return Obx(
      () {
        if (controller.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Total Entries",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${controller.specificOthersData.length} Entries",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "from ${controller.formatDate(controller.selectedDate.value)} up to today",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 15,
                    height: 2.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomDougnutChart(
                  dataSource: controller.getSelectedDataSource(),
                  pointColorMapper: (dynamic point, int index) {
                    if (point is MapEntry<String, dynamic>) {
                      return colorPalette[index % colorPalette.length];
                    }
                    return Colors.transparent;
                  },
                  colorPalette: colorPalette,
                ),
                Expanded(
                  child: Container(
                    height: Get.height,
                    child: Obx(() {
                      if (controller.specificOthersData.isEmpty) {
                        return Center(child: Text("No data available"));
                      } else {
                        return ListView.builder(
                          itemCount: controller.specificOthersData.length,
                          itemBuilder: (context, index) {
                            final MapEntry<String, dynamic> entry = controller
                                .specificOthersData.entries
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
      },
    );
  }
}
