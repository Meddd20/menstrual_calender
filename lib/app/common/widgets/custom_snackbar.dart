import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';

class Ui {
  static GetSnackBar SuccessSnackBar({String title = 'Success', String message = ''}) {
    return GetSnackBar(
      titleText: Text(
        title.tr,
        style: CustomTextStyle.bold(16),
      ),
      messageText: Text(
        message,
        style: CustomTextStyle.medium(14),
      ),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: AppColors.white,
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: const Color.fromARGB(255, 179, 231, 181),
        child: Icon(Icons.check_circle, size: 24, color: Colors.green),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 1500),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error', String message = ''}) {
    return GetSnackBar(
      titleText: Text(
        title.tr,
        style: CustomTextStyle.bold(16),
      ),
      messageText: Text(
        message,
        style: CustomTextStyle.medium(14),
      ),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: AppColors.white,
      icon: CircleAvatar(
        radius: 20,
        backgroundColor: Color.fromARGB(255, 240, 216, 216),
        child: Icon(Icons.error, size: 24, color: Colors.red),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(milliseconds: 1500),
    );
  }
}
