import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle light(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w300,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }

  static TextStyle regular(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w400,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }

  static TextStyle medium(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w500,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }

  static TextStyle semiBold(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w600,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }

  static TextStyle bold(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w700,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }

  static TextStyle extraBold(double fontSize, {double? height, Color? color}) {
    return TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontWeight: FontWeight.w800,
      color: color ?? Colors.black,
      fontSize: fontSize,
      height: height ?? 1.25,
    );
  }
}
