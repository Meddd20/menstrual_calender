import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_snackbar.dart';
import 'package:periodnpregnancycalender/app/models/profile_model.dart';
import 'package:periodnpregnancycalender/app/modules/login/views/login_view.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/change_purpose_view.dart';
import 'package:periodnpregnancycalender/app/modules/profile/views/detail_profile_view.dart';
import 'package:periodnpregnancycalender/app/modules/register/views/register_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/services/firebase_notification_service.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    // Get.put(RegisterController());
    Get.put(OnboardingController());
    Get.put(ProfileController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Profile',
              style: CustomTextStyle.extraBold(22),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: 4,
        ),
        body: FutureBuilder<User?>(
          future: controller.profileUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Align(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: storageService.getCredentialToken() == null,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 20.h),
                          color: Colors.red,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    child: Image.asset(
                                      'assets/icon/alert.png',
                                      width: 24,
                                      height: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      "Register to save your data or log in to access your account",
                                      style: CustomTextStyle.bold(14, height: 1.5, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext buildContext) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 30.h),
                                          child: Wrap(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "Create Account",
                                                    style: CustomTextStyle.bold(22),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "Register to save your data or log in to your existing account to access your data",
                                                    style: CustomTextStyle.medium(16, height: 1.5, color: Colors.black.withOpacity(0.6)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 25),
                                                  CustomButton(
                                                    text: "Create New Account",
                                                    backgroundColor: Color(0xFFE6E5E5),
                                                    prefixIcon: 'assets/icon/register.png',
                                                    textColor: AppColors.black.withOpacity(0.8),
                                                    onPressed: () {
                                                      Get.to(() => RegisterView(isRegisterToExistingData: true), arguments: controller.birthDate.value);
                                                    },
                                                  ),
                                                  SizedBox(height: 15),
                                                  CustomButton(
                                                    text: "Login To Existing Account",
                                                    backgroundColor: Color(0xFFE6E5E5),
                                                    prefixIcon: 'assets/icon/login.png',
                                                    textColor: AppColors.black.withOpacity(0.8),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return SimpleDialog(
                                                            title: Text(
                                                              "Overwrite your existing account data?",
                                                              style: CustomTextStyle.bold(22),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(6.0),
                                                                    child: Text(
                                                                      "Overwriting your data means your existing account data will be overwritten",
                                                                      style: CustomTextStyle.medium(15, height: 1.5),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 10),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      Expanded(
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Get.to(() => LoginView(), arguments: false);
                                                                          },
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
                                                                            "Keep Data",
                                                                            style: CustomTextStyle.bold(16),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: 5),
                                                                      Expanded(
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Get.toNamed(Routes.LOGIN, arguments: true);
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
                                                                            "Overwrite",
                                                                            style: CustomTextStyle.bold(16, color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    shadowColor: Colors.transparent,
                                    minimumSize: Size(Get.width / 3, 40.h),
                                  ),
                                  child: Text(
                                    "Continue",
                                    style: CustomTextStyle.bold(16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => DetailProfileView(), arguments: snapshot.data);
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
                                                    "${snapshot.data?.nama ?? "N/A"}",
                                                    style: CustomTextStyle.bold(24),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    "${snapshot.data?.email ?? "N/A"}",
                                                    style: CustomTextStyle.medium(14),
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
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 25.h),
                                      child: Wrap(
                                        children: [
                                          Obx(
                                            () => Column(
                                              children: [
                                                Image.asset(
                                                  'assets/image/target.png',
                                                  width: 70,
                                                  height: 70,
                                                ),
                                                SizedBox(height: 15),
                                                Text(
                                                  "Usage Preference",
                                                  style: CustomTextStyle.extraBold(22),
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
                                                                style: CustomTextStyle.bold(22),
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
                                                                          style: CustomTextStyle.bold(16),
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
                                                                          style: CustomTextStyle.bold(16, color: Colors.white),
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
                                                              style: CustomTextStyle.extraBold(18, color: Colors.white),
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
                                                                style: CustomTextStyle.bold(22),
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
                                                                          style: CustomTextStyle.bold(16),
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
                                                                          style: CustomTextStyle.bold(16, color: Colors.white),
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
                                                              style: CustomTextStyle.extraBold(18, color: Colors.white),
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 24,
                                            child: Image.asset(
                                              'assets/icon/targets.png',
                                              width: 24,
                                              height: 24,
                                              color: Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Usage Preferences",
                                                style: CustomTextStyle.bold(15, height: 1.75),
                                              ),
                                              Text(
                                                "${controller.purposeText.value}",
                                                style: CustomTextStyle.medium(12, height: 1.75, color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
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
                                              style: CustomTextStyle.bold(15, height: 1.75),
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
                                              style: CustomTextStyle.bold(15, height: 1.75),
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
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(15.w, 35.h, 15.w, 20.h),
                                      child: Wrap(
                                        children: [
                                          Obx(
                                            () => Column(
                                              children: [
                                                Image.asset(
                                                  'assets/image/language.png',
                                                  width: 50,
                                                  height: 50,
                                                ),
                                                SizedBox(height: 15.h),
                                                Text(
                                                  "Change Language",
                                                  style: CustomTextStyle.extraBold(22),
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                      color: controller.selectedLanguage.value == 0 ? AppColors.primary : Colors.grey,
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                                    title: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icon/english.png',
                                                            width: 26,
                                                            height: 26,
                                                          ),
                                                          SizedBox(width: 20),
                                                          Text(
                                                            "English",
                                                            style: CustomTextStyle.bold(16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Radio<int>(
                                                      value: 0,
                                                      groupValue: controller.selectedLanguage.value,
                                                      onChanged: (int? value) {
                                                        controller.setSelectedLanguage(value!);
                                                      },
                                                      activeColor: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                Container(
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    border: Border.all(
                                                      color: controller.selectedLanguage.value == 1 ? AppColors.primary : Colors.grey,
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                                    title: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icon/indonesia.png',
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 20),
                                                          Text(
                                                            "Bahasa Indonesia",
                                                            style: CustomTextStyle.bold(16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    trailing: Radio<int>(
                                                      value: 1,
                                                      groupValue: controller.selectedLanguage.value,
                                                      onChanged: (int? value) {
                                                        controller.setSelectedLanguage(value!);
                                                      },
                                                      activeColor: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 30),
                                                CustomButton(text: "Change Language | Ubah Bahasa", onPressed: () => controller.setLanguage())
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 24,
                                            child: Image.asset(
                                              'assets/icon/globe.png',
                                              width: 24,
                                              height: 24,
                                              color: Colors.black.withOpacity(0.6),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Language",
                                                style: CustomTextStyle.bold(15, height: 1.75),
                                              ),
                                              Text(
                                                "${controller.storageService.getLanguage() == "en" ? "English" : "Bahasa Indonesia"}",
                                                style: CustomTextStyle.medium(12, height: 1.75, color: Colors.black.withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(Iconsax.arrow_right_34)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (storageService.getCredentialToken() != null) ...[
                              SizedBox(height: 15.h),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(10.w, 35.h, 10.w, 20.h),
                                        child: Wrap(
                                          children: [
                                            Obx(
                                              () => Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/image/sync.png',
                                                    width: 55,
                                                    height: 55,
                                                  ),
                                                  SizedBox(height: 15.h),
                                                  Text(
                                                    "Backup Data Preferences",
                                                    style: CustomTextStyle.extraBold(22),
                                                  ),
                                                  SizedBox(height: 20),
                                                  ListTile(
                                                    title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Backup Your Data",
                                                          style: CustomTextStyle.bold(16),
                                                        ),
                                                        SizedBox(height: 4.0),
                                                        Text(
                                                          "Ensure your data is backed up to avoid loss and keep it secure.",
                                                          style: CustomTextStyle.medium(12, height: 1.75, color: Colors.black.withOpacity(0.6)),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: Switch(
                                                      onChanged: (bool value) async {
                                                        final isConnected = await CheckConnectivity().isConnectedToInternet();
                                                        if (!isConnected) {
                                                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                            Get.back();
                                                            await Future.delayed(Duration(milliseconds: 500));
                                                            Get.showSnackbar(Ui.ErrorSnackBar(message: "No internet connection, please try again"));
                                                          });
                                                          return;
                                                        }
                                                        if (controller.isDataBackedup.value == true) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return SimpleDialog(
                                                                title: Column(
                                                                  children: [
                                                                    Container(
                                                                      child: Image.asset(
                                                                        'assets/icon/remove-folder.png',
                                                                        width: 80,
                                                                        height: 80,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 15),
                                                                    Text(
                                                                      "Remove your data backup?",
                                                                      style: CustomTextStyle.bold(22),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ],
                                                                ),
                                                                contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                                                                        child: Text(
                                                                          "Are you sure you want to remove your data backup?",
                                                                          style: CustomTextStyle.medium(15, height: 1.5),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
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
                                                                                "Cancel",
                                                                                style: CustomTextStyle.bold(16),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: 5),
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                              onPressed: () {
                                                                                controller.unbackupData();
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
                                                                                style: CustomTextStyle.bold(16, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          controller.rebackupData();
                                                          Get.back();
                                                        }
                                                      },
                                                      value: controller.isDataBackedup.value!,
                                                      activeColor: AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
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
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 24,
                                              child: Image.asset(
                                                'assets/icon/storage.png',
                                                width: 24,
                                                height: 24,
                                                color: Colors.black.withOpacity(0.6),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Backup Data Preferences",
                                                  style: CustomTextStyle.bold(15, height: 1.75),
                                                ),
                                                Text(
                                                  "${controller.isDataBackedup.value == true ? "Data Backed Up" : "Data Not Backed Up"}",
                                                  style: CustomTextStyle.medium(12, height: 1.75, color: Colors.black.withOpacity(0.6)),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Icon(Iconsax.arrow_right_34)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            SizedBox(height: 15.h),
                            GestureDetector(
                              onTap: () {
                                FirebaseNotificationService().storeFcmToken(controller.storageService.getAccountId()!);
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
                                          Expanded(
                                            child: Text(
                                              "About this application",
                                              style: CustomTextStyle.bold(15, height: 1.75),
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
                            Visibility(
                              visible: storageService.getCredentialToken() != null,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Column(
                                          children: [
                                            Container(
                                              child: Image.asset(
                                                'assets/icon/good-bye.png',
                                                width: 80,
                                                height: 80,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Logging Out?",
                                              style: CustomTextStyle.bold(22),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                                                child: Text(
                                                  "Make sure to backup your data before logging out.",
                                                  style: CustomTextStyle.medium(15, height: 1.5),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
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
                                                        "Cancel",
                                                        style: CustomTextStyle.bold(16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        controller.performLogout();
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
                                                        "Logout",
                                                        style: CustomTextStyle.bold(16, color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
                                            style: CustomTextStyle.extraBold(15, height: 1.75, color: AppColors.primary),
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
                      ),
                    ],
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
