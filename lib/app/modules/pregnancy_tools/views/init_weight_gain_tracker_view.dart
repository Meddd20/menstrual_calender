import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/modules/pregnancy_tools/controllers/weight_tracker_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                AppLocalizations.of(context)!.pregnancyWeightGainTracker,
                style: CustomTextStyle.extraBold(24, height: 1.5),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.pregnancyWeightGainTrackerDesc,
                style: CustomTextStyle.medium(14, height: 1.75, color: Colors.black.withOpacity(0.6)),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.countBMI,
                style: CustomTextStyle.extraBold(18, height: 1.5),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.prePregnancyWeight,
                          style: CustomTextStyle.bold(14, height: 1.5),
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
                                            AppLocalizations.of(context)!.addPrePregnancyWeight,
                                            style: CustomTextStyle.bold(20, height: 1.5),
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
                                                  textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                  selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
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
                                                  style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                ),
                                                NumberPicker(
                                                  minValue: 0,
                                                  maxValue: 9,
                                                  value: controller.selectedWeightDecimal ?? 0,
                                                  onChanged: controller.setSelectedWeightDecimal,
                                                  textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                  selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
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
                                                  style: CustomTextStyle.extraBold(20, color: AppColors.primary),
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
                                        text: AppLocalizations.of(context)!.add,
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
                                  (weight != 0.0) ? "$weight Kg" : AppLocalizations.of(context)!.weight,
                                  style: CustomTextStyle.bold(16, height: 1.75, color: (weight != 0.0) ? Colors.black : Colors.black.withOpacity(0.6)),
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
                          AppLocalizations.of(context)!.yourHeight,
                          style: CustomTextStyle.bold(14, height: 1.5),
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
                                                AppLocalizations.of(context)!.addHeight,
                                                style: CustomTextStyle.bold(20, height: 1.5),
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
                                                    textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                    selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
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
                                                    style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                  ),
                                                  NumberPicker(
                                                    minValue: 0,
                                                    maxValue: 9,
                                                    value: controller.selectedInitHeightDecimal ?? 0,
                                                    onChanged: controller.setSelectedInitHeightDecimal,
                                                    textStyle: CustomTextStyle.light(18, color: Colors.grey),
                                                    selectedTextStyle: CustomTextStyle.extraBold(24, color: AppColors.primary),
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
                                                    style: CustomTextStyle.extraBold(20, color: AppColors.primary),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: CustomButton(
                                        text: AppLocalizations.of(context)!.add,
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
                                  (height != 0.0) ? "$height cm" : AppLocalizations.of(context)!.height,
                                  style: CustomTextStyle.bold(16, height: 1.75, color: (height != 0.0) ? Colors.black : Colors.black.withOpacity(0.6)),
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
                    AppLocalizations.of(context)!.twinBaby,
                    style: CustomTextStyle.bold(14, height: 1.5),
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
                text: AppLocalizations.of(context)!.send,
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
