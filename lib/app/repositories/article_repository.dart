import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/models/article_model.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class ArticleRepository {
  final ApiService apiService;

  ArticleRepository(this.apiService);

  Future<Article?> getAllArticle(String? tags) async {
    try {
      http.Response response = await apiService.getAllArticle(tags);

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson =
            jsonDecode(response.body)["articles"];
        final List<Articles> articles = articlesJson
            .map<Articles>((articleJson) => Articles.fromJson(articleJson))
            .toList();

        return Article(articles: articles);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
