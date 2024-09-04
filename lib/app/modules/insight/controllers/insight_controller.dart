import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/article_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/article_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/conectivity.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class InsightController extends GetxController {
  final ApiService apiService = ApiService();
  late final ArticleRepository articleRepository = ArticleRepository(apiService);
  final storageService = StorageService();
  var selectedTag = "".obs;
  var isLoading = RxBool(true);
  RxList<Articles> articles = <Articles>[].obs;
  late Future<void> articlesFuture;
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    articlesFuture = fetchArticles(null);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<String> filterTags = [
    "Premenstrual Syndrome (PMS)",
    "Pregnancy",
    "Ovulation",
    "Menstruation",
    "Trying to conceive",
    "Fertility",
    "Sex",
    "Perimenopause",
    "Birth Control",
  ];

  String getSelectedTag() => selectedTag.value;

  void setSelectedTag(String value) {
    selectedTag.value = value;
    fetchArticles(selectedTag.value);
    update();
  }

  Map<String, String> getTagTranslations(BuildContext context) {
    return {
      "Premenstrual Syndrome (PMS)": AppLocalizations.of(context)!.premenstrualSyndrome,
      "Pregnancy": AppLocalizations.of(context)!.pregnancy,
      "Ovulation": AppLocalizations.of(context)!.ovulation,
      "Menstruation": AppLocalizations.of(context)!.menstruation,
      "Trying to conceive": AppLocalizations.of(context)!.tryingToConceive,
      "Fertility": AppLocalizations.of(context)!.fertility,
      "Sex": AppLocalizations.of(context)!.sex,
      "Perimenopause": AppLocalizations.of(context)!.perimenopause,
      "Birth Control": AppLocalizations.of(context)!.birthControl,
    };
  }

  Future<void> fetchArticles(String? tags) async {
    try {
      isConnected.value = await CheckConnectivity().isConnectedToInternet();
      if (isConnected.value) {
        isLoading.value = true;
      } else {
        isLoading.value = false;
      }

      Article? result;

      if (selectedTag.value.isEmpty) {
        result = await articleRepository.getAllArticle(null);
      } else {
        result = await articleRepository.getAllArticle(selectedTag.value);
      }

      if (result != null) {
        if (result.articles != null) {
          articles.assignAll(result.articles!);
        } else {
          print("Error: articles field is null in the response");
        }
      } else {
        print("Error: Unable to fetch articles");
      }
    } catch (e) {
      print("Error fetching articles: $e");
    } finally {
      isLoading(false);
    }

    update();
  }
}
