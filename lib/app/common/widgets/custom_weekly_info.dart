import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyInfo extends StatelessWidget {
  final String title;
  final String imagePath;
  final Function() onTap;

  const WeeklyInfo({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 2.0, 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                height: Get.height,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF4D5).withOpacity(0.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
