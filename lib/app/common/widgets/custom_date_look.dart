import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';

class CustomDateLook extends StatelessWidget {
  final MapEntry<String, dynamic> entry;

  CustomDateLook({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
              // border: Border.all(width: 1),
              ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('dd').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 24.sp,
                            height: 1,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 15.sp,
                            height: 1,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy').format(DateTime.parse(entry.key)),
                          style: TextStyle(
                            fontSize: 12.sp,
                            height: 2,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 80,
                    width: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.highlight,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value.toString().replaceAll('[', '').replaceAll(']', ''),
                      overflow: TextOverflow.visible,
                      style: CustomTextStyle.captionTextStyle(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
