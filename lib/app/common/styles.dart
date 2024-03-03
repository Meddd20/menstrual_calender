import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextStyle {
  static TextStyle heading1TextStyle({Color? color}) {
    return TextStyle(
      fontSize: 24.sp,
      height: 1.25,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading2TextStyle({Color? color}) {
    return TextStyle(
      fontSize: 22.sp,
      height: 1.25,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading3TextStyle({Color? color}) {
    return TextStyle(
      fontSize: 20.sp,
      height: 1.25,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle heading4TextStyle({Color? color}) {
    return TextStyle(
      fontSize: 18.sp,
      height: 1.25,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle captionTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      height: 1.5,
      fontFamily: 'Poppins',
      letterSpacing: 0.45,
      color: color ?? Colors.black,
    );
  }

  static TextStyle bodyTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      height: 2.0,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
    );
  }

  static TextStyle buttonTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      letterSpacing: 0.38,
      fontFamily: 'Poppins',
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle headerCalenderTextStyle({Color? color}) {
    return TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle weekCalenderTextStyle({Color? color}) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }

  static TextStyle monthlyCalenderTextStyle({Color? color}) {
    return TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }

  static TextStyle selectionCalenderTextStyle({Color? color}) {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }
}
