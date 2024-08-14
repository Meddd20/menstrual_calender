import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';

class CustomDateLook extends StatelessWidget {
  final MapEntry<String, dynamic> entry;
  final String type;

  CustomDateLook({required this.entry, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
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
                          style: CustomTextStyle.extraBold(24),
                        ),
                        Text(
                          DateFormat('MMM').format(DateTime.parse(entry.key)),
                          style: CustomTextStyle.bold(15),
                        ),
                        Text(
                          DateFormat('yyyy').format(DateTime.parse(entry.key)),
                          style: CustomTextStyle.bold(12),
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
                      "${entry.value.toString().replaceAll('[', '').replaceAll(']', '')} ${type == 'weight' ? 'Kg' : type == 'temperature' ? '°C' : ''}",
                      overflow: TextOverflow.visible,
                      style: CustomTextStyle.medium(16, height: 1.5),
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
