import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';

class CustomTabBar extends StatelessWidget {
  final Function(int) onTap;
  final TabController controller;

  CustomTabBar({required this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xFFFefeff0),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.white,
        ),
        dividerColor: AppColors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(2),
        labelColor: Colors.black,
        onTap: onTap,
        unselectedLabelColor: Color(0xFFC7C7C7),
        tabs: [
          Tab(
            child: Text(
              '30 Days',
              style: CustomTextStyle.bold(12),
            ),
          ),
          Tab(
            child: Text(
              '3 Months',
              style: CustomTextStyle.bold(12),
            ),
          ),
          Tab(
            child: Text(
              '6 Months',
              style: CustomTextStyle.bold(12),
            ),
          ),
          Tab(
            child: Text(
              '1 Year',
              style: CustomTextStyle.bold(12),
            ),
          ),
        ],
      ),
    );
  }
}
