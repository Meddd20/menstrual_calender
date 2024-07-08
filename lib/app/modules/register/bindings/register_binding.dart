import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/modules/register/controllers/register_verification_controller.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());

    Get.lazyPut<RegisterVerificationController>(
      () => RegisterVerificationController(),
    );
  }
}
