import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_calendar_datepicker.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_textformfield.dart';
import 'package:periodnpregnancycalender/app/modules/profile/controllers/detail_profile_controller.dart';

class DetailProfileView extends GetView<DetailprofileController> {
  const DetailProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DetailprofileController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Settings'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 40.h, 10.w, 15.h),
          child: Align(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100.h,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset("assets/icon/globe.png"),
                ),
                SizedBox(height: 25.h),
                CustomTextFormField(
                  controller: controller.namaC,
                  labelText: "Nama",
                  keyboardType: TextInputType.name,
                  onChanged: (text) {
                    if (controller.namaC.text != controller.originalNama) {
                      controller.isChanged.value = true;
                      controller.update();
                    }
                  },
                ),
                SizedBox(height: 15.h),
                CustomTextFormField(
                  controller: controller.emailC,
                  labelText: "Email",
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15.h),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 20.h),
                          child: Wrap(
                            children: [
                              Obx(
                                () => Column(
                                  children: [
                                    Container(
                                      child: CustomCalendarDatePicker(
                                        value: [controller.userBirthday.value],
                                        onValueChanged: (dates) {
                                          controller.userBirthday.value = dates.isNotEmpty ? dates[0] ?? DateTime.now() : DateTime.now();
                                          controller.update();
                                        },
                                        lastDate: DateTime.now(),
                                        calendarType: CalendarDatePicker2Type.single,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    CustomButton(
                                      text: "Save",
                                      onPressed: () {
                                        controller.setEditedBirthday();
                                        Get.back();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: GestureDetector(
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: controller.birthdayC,
                        labelText: "Date of Birth",
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(
                  () => CustomButton(
                    text: "Edit Profile",
                    onPressed: () {
                      if (controller.isChanged.value) {
                        controller.updateProfile(context);
                      }
                    },
                    backgroundColor: controller.isChanged.value ? AppColors.primary : Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
