import 'package:flutter/material.dart';

class CustomCircularIcon extends StatelessWidget {
  final IconData iconData;
  final double iconSize;
  final Color iconColor;
  final Color containerColor;
  final double containerSize;

  CustomCircularIcon({
    required this.iconData,
    required this.iconSize,
    required this.iconColor,
    required this.containerColor,
    required this.containerSize,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: containerSize,
      backgroundColor: containerColor,
      child: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
