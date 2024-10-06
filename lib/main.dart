import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import 'package:periodnpregnancycalender/l10n/l10n.dart';
import 'package:periodnpregnancycalender/app/services/firebase_notification_service.dart';
import 'package:periodnpregnancycalender/app/services/local_notification_service.dart';
import 'package:periodnpregnancycalender/app/utils/database_helper.dart';
import 'package:periodnpregnancycalender/firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DatabaseHelper.instance.database;
  await LocalNotificationService().init();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationService.initNotifications();

  await LocalNotificationService().requestNotificationPermission();
  // runApp(DevicePreview(
  //   // enabled: !kReleaseMode,
  //   builder: (context) => MyApp(),
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isAuth = StorageService().getIsAuth();
    final initialRoute = isAuth == false
        ? Routes.ONBOARDING
        : StorageService().isPinSecure()
            ? Routes.PIN
            : Routes.NAVIGATION_MENU;

    return ScreenUtilInit(
      builder: (_, child) {
        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            useMaterial3: true,
          ),
          title: "Period and Pregnancy Calendar",
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
          getPages: AppPages.routes,
          supportedLocales: L10n.all,
          locale: Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
      designSize: const Size(360, 800),
    );
  }
}
