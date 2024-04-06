import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await GetStorage.init();
  // await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isAuth = box.read('isAuth');
    final initialRoute = isAuth ? Routes.NAVIGATION_MENU : Routes.ONBOARDING;
    return ScreenUtilInit(
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
          ),
          title: "Period and Pregnancy Calendar",
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
      designSize: const Size(360, 800),
    );
  }
}
