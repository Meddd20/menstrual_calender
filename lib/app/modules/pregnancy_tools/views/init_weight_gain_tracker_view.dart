import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_tracker_controller.dart';

class InitWeightGainTrackerView extends GetView<WeightTrackerController> {
  final String? isTwin;
  const InitWeightGainTrackerView({Key? key, this.isTwin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isTwin != null) {
      isTwin == "0" ? controller.isTwin.value = false : controller.isTwin.value = true;
      print(controller.isTwin.value);
    }
    Get.find<WeightTrackerController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
          child: Column(
            children: [
              Text(
                "Pregnancy Weight Gain Tracker",
                style: TextStyle(
                  fontSize: 26.sp,
                  height: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                "The pregnancy weight gain tracker monitors and records a pregnant woman's weight throughout her pregnancy using BMI to categorize weight status.",
                style: TextStyle(
                  fontSize: 16.sp,
                  height: 1.75,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  wordSpacing: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 40),
              Text(
                "Enter your height and pre-pregnancy weight",
                style: TextStyle(
                  fontSize: 18.sp,
                  height: 1.75,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  wordSpacing: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Pre-pregnancy weight",
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.75,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            wordSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                                      width: Get.width,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Add Pre-Pregnancy Weight",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Obx(
                                            () => Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                NumberPicker(
                                                  minValue: 30,
                                                  maxValue: 150,
                                                  value: controller.selectedWeight ?? 0,
                                                  onChanged: controller.setSelectedWeight,
                                                  textStyle: TextStyle(color: Colors.grey),
                                                  selectedTextStyle: TextStyle(
                                                    color: Color(0xFFFF6868),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  infiniteLoop: true,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(color: Colors.black),
                                                      bottom: BorderSide(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ".",
                                                  style: TextStyle(
                                                    color: Color(0xFFFF6868),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                NumberPicker(
                                                  minValue: 0,
                                                  maxValue: 9,
                                                  value: controller.selectedWeightDecimal ?? 0,
                                                  onChanged: controller.setSelectedWeightDecimal,
                                                  textStyle: TextStyle(color: Colors.grey),
                                                  selectedTextStyle: TextStyle(
                                                    color: Color(0xFFFF6868),
                                                    fontSize: 24.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  infiniteLoop: true,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(color: Colors.black),
                                                      bottom: BorderSide(color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Kg",
                                                  style: TextStyle(
                                                    color: Color(0xFFFF6868),
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CustomButton(
                                        text: "Add",
                                        onPressed: () {
                                          controller.updateWeight();
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(() {
                                final weight = controller.getWeight();
                                return Text(
                                  (weight != 0.0) ? "$weight Kg" : "Weight",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.75,
                                    color: (weight != 0.0) ? Colors.black : Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w700,
                                    wordSpacing: 1.5,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Your height",
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.75,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            wordSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: [
                                    Obx(() => Container(
                                          padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 10.h),
                                          width: Get.width,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Add Pre-Pregnancy Weight",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  NumberPicker(
                                                    minValue: 125,
                                                    maxValue: 200,
                                                    value: controller.selectedInitHeight ?? 0,
                                                    onChanged: controller.setSelectedInitHeight,
                                                    textStyle: TextStyle(color: Colors.grey),
                                                    selectedTextStyle: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 24.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    infiniteLoop: true,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(color: Colors.black),
                                                        bottom: BorderSide(color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    ".",
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 24.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  NumberPicker(
                                                    minValue: 0,
                                                    maxValue: 9,
                                                    value: controller.selectedInitHeightDecimal ?? 0,
                                                    onChanged: controller.setSelectedInitHeightDecimal,
                                                    textStyle: TextStyle(color: Colors.grey),
                                                    selectedTextStyle: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 24.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    infiniteLoop: true,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(color: Colors.black),
                                                        bottom: BorderSide(color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "cm",
                                                    style: TextStyle(
                                                      color: Color(0xFFFF6868),
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CustomButton(
                                        text: "Add",
                                        onPressed: () {
                                          controller.updateHeight();
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 70.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Obx(() {
                                final height = controller.getHeight();
                                return Text(
                                  (height != 0.0) ? "$height cm" : "Height",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    height: 1.75,
                                    color: (height != 0.0) ? Colors.black : Colors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w700,
                                    wordSpacing: 1.5,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pregnant with twin baby?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.75,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      wordSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Obx(
                    () => Switch(
                      value: controller.isTwin.value,
                      onChanged: (bool twin) {
                        controller.isTwin.value = twin;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              CustomButton(
                text: "Send",
                onPressed: () {
                  controller.initializeWeightGain(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
