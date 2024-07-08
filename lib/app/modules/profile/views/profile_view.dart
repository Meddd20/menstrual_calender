import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/change_purpose_view.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/detail_profile_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Get.find<ProfileController>().fetchProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // var user = controller.profile.value!.userData!.user!;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Get.to(() => DetailProfileView(), arguments: user);
                          },
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
                                                "a",
                                                // user.nama != null ? user.nama ?? 'N/A' : 'N/A',
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 5.h),
                                              Text(
                                                "a",
                                                // user.email != null ? user.isEmail ?? 'N/A' : 'N/A',
                                                style: TextStyle(
                                                  color: Color(0xFF090A0A),
                                                  fontSize: 13.sp,
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
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 25.h),
                                  child: Wrap(
                                    children: [
                                      Obx(
                                        () => Column(
                                          children: [
                                            Text(
                                              "My goal",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 22,
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              width: Get.width,
                                              height: 120.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: RadioListTile<int>(
                                                value: 0,
                                                groupValue: controller.radioGoalSelect.value,
                                                onChanged: (int? value) {
                                                  if (value != null && controller.getRadioGoalSelect != value) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SimpleDialog(
                                                          title: Text(
                                                            "Are you sure you want to change your goal?",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.all(16.0),
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () => Get.back(),
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                      elevation: 0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      shadowColor: Colors.transparent,
                                                                      minimumSize: Size(Get.width, 45.h),
                                                                    ),
                                                                    child: Text(
                                                                      "No",
                                                                      style: CustomTextStyle.buttonTextStyle(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 5),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Get.to(() => ChangePurposeView());
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: AppColors.primary,
                                                                      elevation: 0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      shadowColor: AppColors.primary,
                                                                      minimumSize: Size(Get.width, 45.h),
                                                                    ),
                                                                    child: Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                        fontSize: 16.sp,
                                                                        letterSpacing: 0.38,
                                                                        fontFamily: 'Poppins',
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                  //   controller
                                                  //       .setRadioGoalSelect(
                                                  //           value ?? 0);
                                                  // }
                                                },
                                                activeColor: Colors.white,
                                                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                                                hoverColor: Colors.black,
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 8),
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          "Tracking Menstrual Period",
                                                          style: CustomTextStyle.heading4TextStyle(color: Colors.white),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 120.h,
                                                        alignment: Alignment.centerRight,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(30),
                                                          child: Image.asset(
                                                            "assets/a0ffb3b8a7b12e87a13bac8ea30839d9.png",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                              width: Get.width,
                                              height: 120.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: RadioListTile<int>(
                                                value: 1,
                                                groupValue: controller.radioGoalSelect.value,
                                                onChanged: (int? value) {
                                                  if (value != null && controller.getRadioGoalSelect != value) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SimpleDialog(
                                                          title: Text(
                                                            "Are you sure you want to change your goal?",
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                          contentPadding: EdgeInsets.all(16.0),
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () => Get.back(),
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Colors.transparent,
                                                                      elevation: 0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      shadowColor: Colors.transparent,
                                                                      minimumSize: Size(Get.width, 45.h),
                                                                    ),
                                                                    child: Text(
                                                                      "No",
                                                                      style: CustomTextStyle.buttonTextStyle(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(width: 5),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    onPressed: () {
                                                                      Get.to(() => ChangePurposeView());
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: AppColors.primary,
                                                                      elevation: 0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      shadowColor: AppColors.primary,
                                                                      minimumSize: Size(Get.width, 45.h),
                                                                    ),
                                                                    child: Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                        fontSize: 16.sp,
                                                                        letterSpacing: 0.38,
                                                                        fontFamily: 'Poppins',
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    controller.setRadioGoalSelect(value ?? 1);
                                                  }
                                                },
                                                activeColor: Colors.white,
                                                contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 8),
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          "Follow Pregnancy",
                                                          style: CustomTextStyle.heading4TextStyle(color: Colors.white),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 120.h,
                                                        alignment: Alignment.centerRight,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(30),
                                                          child: Image.asset(
                                                            "assets/582f6eee055d99f5cec860e1df879f99.png",
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ).then((value) {
                              controller.usePurpose();
                            });
                          },
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          color: AppColors.highlight,
                                        ),
                                        child: Icon(
                                          Iconsax.wind,
                                          size: 15,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "My Goal",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                height: 2.0,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${controller.purposeText.value}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {},
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Reminders",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 2.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {},
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Themes",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 2.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {},
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Secure Access (PIN)",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 2.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {},
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Language",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 2.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {},
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "About this application",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            height: 2.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Iconsax.arrow_right_34)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        GestureDetector(
                          onTap: () {
                            controller.performLogout();
                          },
                          child: Wrap(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: Text(
                                      "Log Out",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        height: 2.0,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
