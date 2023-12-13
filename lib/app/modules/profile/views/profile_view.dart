import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Wrap(
                  children: [
                    Container(
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15.h),
                                    Text(
                                      'Medhiko Biraja',
                                      style: TextStyle(
                                        color: Color(0xFF090A0A),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      'mbirajabiraja@gmail.com',
                                      style: TextStyle(
                                        color: Color(0xFF090A0A),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                  ],
                                ),
                                Icon(Iconsax.arrow_right_34)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.h,
                thickness: 0.5,
              ),
              SizedBox(height: 20.h),
              Text(
                "My Goal",
                style: TextStyle(
                  color: Color(0xFF090A0A),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 140.h,
                      width: Get.width,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Color(0xFFFFD7DF),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Positioned.directional(
                              textDirection: TextDirection.ltr,
                              child: Container(
                                padding: EdgeInsets.only(left: 10.w, top: 10.h),
                                width: 70.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Track Cycle",
                                      style: TextStyle(
                                        color: Color(0xFF090A0A),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "Track your menstrual cycle",
                                      style: TextStyle(
                                        color: Color(0xFF090A0A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 90.w,
                                height: 120.h,
                                child: Image.asset(
                                  "assets/a0ffb3b8a7b12e87a13bac8ea30839d9.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      color: Color(0xFFFFE69E),
                      height: 50,
                      // Other properties and child widgets...
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                height: 50.h,
                width: Get.width,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Color(0xFFFFD7DF),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
