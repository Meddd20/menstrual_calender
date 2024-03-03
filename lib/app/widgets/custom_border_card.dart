import 'package:flutter/material.dart';

class CustomBorderCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final double width;
  final double height;

  const CustomBorderCard({
    required this.color,
    required this.child,
    this.width = double.infinity,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: Container(
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
