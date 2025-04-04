import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

class AddPeriodBottomSheetWidget extends StatelessWidget {
  final void Function()? closeModalBottomSheet;
  final String title;
  final Obx startDate;
  final Obx endDate;
  final void Function() addPeriodOnPressedButton;
  final List<DateTime?> calenderValue;
  final dynamic Function(List<DateTime?>) calenderOnValueChanged;
  final bool isEdit;
  final String buttonCaption;

  AddPeriodBottomSheetWidget({
    required this.closeModalBottomSheet,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.addPeriodOnPressedButton,
    required this.calenderValue,
    required this.calenderOnValueChanged,
    required this.buttonCaption,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 25.h, 10.w, 0.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: CustomTextStyle.extraBold(20.sp),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 25,
                              color: const Color(0xFFFD6666),
                            ),
                            onPressed: closeModalBottomSheet,
                          )
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: Get.width,
                        child: Text(
                          AppLocalizations.of(context)!.updatePeriodCycleDesc,
                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.startDate,
                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: startDate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.endDate,
                          style: CustomTextStyle.medium(14, height: 1.5, color: Colors.black.withOpacity(0.6)),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: endDate,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    Icon(Iconsax.calendar),
                  ],
                ),
              )
            ],
          ),
          CustomCalendarDatePicker(
            value: calenderValue,
            onValueChanged: calenderOnValueChanged,
            lastDate: DateTime.now(),
            calendarType: CalendarDatePicker2Type.range,
          ),
          SizedBox(height: 20.h),
          CustomButton(text: buttonCaption, onPressed: addPeriodOnPressedButton),
          isEdit ? SizedBox(height: 5.h) : SizedBox.shrink(),
          if (isEdit)
            CustomButton(
              text: AppLocalizations.of(context)!.cancel,
              onPressed: () => Get.back(),
              backgroundColor: Colors.transparent,
              textColor: Colors.black,
            ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
