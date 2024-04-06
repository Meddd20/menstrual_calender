import 'dart:async';
import 'package:get/get.dart';
import 'package:periodnpregnancycalender/app/models/article_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/repositories/article_repository.dart';

class InsightController extends GetxController {
  final ApiService apiService = ApiService();
  late final ArticleRepository articleRepository =
      ArticleRepository(apiService);
  var selectedTag = "".obs;
  var isLoading = RxBool(true);
  RxList<Articles> articles = <Articles>[].obs;
  late Future<void> articlesFuture;

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

  Future<void> fetchArticles(String? tags) async {
    try {
      isLoading.value = true;
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
