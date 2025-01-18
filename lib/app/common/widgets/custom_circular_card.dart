import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

class CustomCircularCard extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback? onTap;

  const CustomCircularCard({
    required this.iconPath,
    required this.text,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      iconPath,
                      fit: BoxFit.contain,
                      // color: AppColors.primary,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.medium(13, height: 1.5),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}
