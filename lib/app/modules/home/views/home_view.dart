import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_menstruation_view.dart';
import 'package:periodnpregnancycalender/app/modules/home/views/home_pregnancy_view.dart';

class HomeView extends GetView {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return box.read("isPregnant") == "0"
        ? HomeMenstruationView()
        : HomePregnancyView();
  }
}
