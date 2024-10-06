import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/common/widgets/custom_button.dart';
import 'package:periodnpregnancycalender/app/routes/app_pages.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';
import '../controllers/onboarding_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/onboarding/views/onboarding1_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 15.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: Get.width / 2,
                          ),
                          child: DropdownButtonFormField<Locale>(
                            value: Get.locale,
                            items: [
                              DropdownMenuItem(
                                value: Locale('id'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Bahasa Indonesia'),
                                    Image.asset(
                                      'assets/icon/indonesia.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: Locale('en'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('English'),
                                    Image.asset(
                                      'assets/icon/english.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                              ),
                            ),
                            onChanged: (Locale? newLocale) {
                              if (newLocale != null) {
                                Get.updateLocale(newLocale);
                                StorageService().setLanguage(newLocale.languageCode);
                              }
                            },
                            icon: SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: Get.width,
                    height: 280.h,
                    child: Image.asset('assets/image/bd48b2bc7befdf66265a70239c555886.png'),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    AppLocalizations.of(context)!.welcomeMsg,
                    style: CustomTextStyle.bold(22, height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    AppLocalizations.of(context)!.welcomeMsgDesc,
                    style: CustomTextStyle.medium(14, height: 2.0),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  CustomButton(
                    text: AppLocalizations.of(context)!.haveAccount,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    text: AppLocalizations.of(context)!.getStarted,
                    onPressed: () {
                      Get.to(() => Onboarding1View());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
