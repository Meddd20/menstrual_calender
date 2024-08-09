import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';

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
    return Expanded(
      child: Container(
        height: 115.h,
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
                  // CustomCircularIcon(
                  //   iconData: icons,
                  //   iconSize: 25,
                  //   iconColor: primaryColor,
                  //   containerColor: AppColors.white,
                  //   containerSize: 15.dg,
                  // ),
                  Text(
                    daysLeft,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                predictionType,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                datePrediction,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
