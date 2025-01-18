import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

class CustomCardPrediction extends StatelessWidget {
  final Color containerColor;
  final Color primaryColor;
  final String daysLeft;
  final String predictionType;
  final String datePrediction;
  final String iconPath;

  CustomCardPrediction({
    required this.containerColor,
    required this.primaryColor,
    required this.daysLeft,
    required this.predictionType,
    required this.datePrediction,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: containerColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.white,
                      child: Image.asset(
                        iconPath,
                        width: 25,
                        // height: 22,
                      ),
                    ),
                    Text(
                      daysLeft,
                      style: CustomTextStyle.semiBold(12),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  predictionType,
                  style: CustomTextStyle.extraBold(16, color: primaryColor, height: 1.5),
                ),
                Text(
                  datePrediction,
                  style: CustomTextStyle.semiBold(14.sp),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
