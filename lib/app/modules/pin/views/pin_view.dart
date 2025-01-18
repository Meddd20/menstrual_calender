import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/pin_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/common/common.dart';

enum PinMode { setup, confirm, enter }

class PinView extends GetView<PinController> {
  final PinMode? mode;
  const PinView({Key? key, this.mode = PinMode.enter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final effectiveMode = mode ?? PinMode.enter;
    Get.put(PinController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.w, 110.h, 15.w, 20.h),
        child: Obx(
          () => Column(
            children: [
              Text(
                mode == PinMode.setup
                    ? AppLocalizations.of(context)!.setPinCode
                    : mode == PinMode.confirm
                        ? AppLocalizations.of(context)!.confirmPinCode
                        : AppLocalizations.of(context)!.enterPin,
                style: CustomTextStyle.extraBold(24, height: 2.0),
              ),
              Text(
                controller.getDescription(effectiveMode, controller.isError.value, context),
                style: CustomTextStyle.medium(16, height: 1.5, color: AppColors.black.withOpacity(0.6)),
              ),
              SizedBox(height: 90),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) {
                      bool isFilled = index < controller.pin.value.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: isFilled ? AppColors.primary : Color(0xFFECECEC),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 70),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 1,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      controller.addDigitPin((index + 1).toString(), effectiveMode);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      minimumSize: Size(10, 10),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: CustomTextStyle.bold(24),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (effectiveMode == PinMode.enter) {
                          null;
                        }
                        controller.storageService.currentPin('');
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        minimumSize: Size(80, 80),
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text(
                        effectiveMode == PinMode.enter ? "" : AppLocalizations.of(context)!.cancel,
                        style: CustomTextStyle.semiBold(16),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        controller.addDigitPin(0.toString(), mode ?? PinMode.enter);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        minimumSize: Size(80, 80),
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text(
                        "0",
                        style: CustomTextStyle.bold(24),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Obx(
                    () => Expanded(
                      child: TextButton(
                        onPressed: controller.pin.value.isEmpty
                            ? null
                            : () {
                                controller.removeDigitPin();
                              },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          minimumSize: Size(80, 80),
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(
                          Icons.backspace,
                          size: 24,
                          color: controller.pin.value.isEmpty ? Colors.black.withOpacity(0.6) : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
