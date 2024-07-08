import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final isAuth = box.read('isAuth') ?? false;
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
