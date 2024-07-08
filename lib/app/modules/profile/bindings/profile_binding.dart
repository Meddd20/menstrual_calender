import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/repositories/local/profile_repository.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseHelper>(() => DatabaseHelper.instance);

    Get.lazyPut<LocalProfileRepository>(
      () => LocalProfileRepository(Get.find<DatabaseHelper>()),
    );

    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
