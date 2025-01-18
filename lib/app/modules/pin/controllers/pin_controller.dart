import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/pin/views/pin_view.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:periodnpregnancycalender/app/utils/utils.dart';

class PinController extends GetxController {
  final storageService = StorageService();
  var pin = ''.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getDescription(PinMode mode, bool? isError, context) {
    if (isError != null && isError) {
      return AppLocalizations.of(context)!.errorPinCode;
    }
    if (mode == PinMode.setup) {
      return AppLocalizations.of(context)!.setPinCodeDescription;
    } else if (mode == PinMode.confirm) {
      return AppLocalizations.of(context)!.confirmPinCodeDescription;
    } else {
      return AppLocalizations.of(context)!.enterPinDesc;
    }
  }

  void addDigitPin(String digit, PinMode mode) {
    if (pin.value.length < 4) {
      pin.value += digit;
    }

    if (pin.value.length == 4) {
      if (mode == PinMode.setup) {
        storageService.currentPin(pin.value);
        Get.offAll(() => PinView(mode: PinMode.confirm));
      } else if (mode == PinMode.confirm) {
        if (isPinMatching()) {
          storageService.setPin(true);
          storageService.currentPin(pin.value);
          Get.offAllNamed(Routes.NAVIGATION_MENU);
        } else {
          isError.value = true;
        }
      } else {
        if (storageService.getCurrentPin() == pin.value) {
          Get.offAllNamed(Routes.NAVIGATION_MENU);
        } else {
          isError.value = true;
        }
      }
    }
  }

  void removeDigitPin() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  void clearPin() {
    pin.value = '';
  }

  bool isPinMatching() {
    return pin.value == storageService.getCurrentPin();
  }
}
