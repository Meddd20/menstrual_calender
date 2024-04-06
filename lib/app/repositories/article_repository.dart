import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:periodnpregnancycalender/app/models/article_model.dart'
    as ArticleModel;
import 'package:periodnpregnancycalender/app/models/detail_article_model.dart'
    as DetailArticleModel;
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class ArticleRepository {
  final ApiService apiService;

  ArticleRepository(this.apiService);

  Future<ArticleModel.Article?> getAllArticle(String? tags) async {
    try {
      http.Response response = await apiService.getAllArticle(tags);

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = jsonDecode(response.body)["data"];
        final List<ArticleModel.Articles> articles = articlesJson
            .map<ArticleModel.Articles>(
                (articleJson) => ArticleModel.Articles.fromJson(articleJson))
            .toList();

        return ArticleModel.Article(articles: articles);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<DetailArticleModel.ArticleData?> getArticle(String id) async {
    try {
      http.Response response = await apiService.getArticle(id);

      if (response.statusCode == 200) {
        var decodedJson =
            json.decode(response.body.toString().replaceAll("\n", ""));
        var articleData = DetailArticleModel.ArticleData.fromJson(decodedJson);
        return articleData;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e, stacktrace) {
      print("Error: $e");
      print(stacktrace);
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> storeComment(
      String? parentId, String articleId, String content) async {
    try {
      http.Response response =
          await apiService.storeComment(parentId, articleId, content);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> likeComment(
      String userId, String commentId) async {
    try {
      http.Response response =
          await apiService.likeComment(userId, commentId);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }

  Future<Map<String, dynamic>> deleteComment(String id) async {
    try {
      http.Response response = await apiService.deleteComment(id);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown error occurred";
      }
    } catch (e) {
      print("Error: $e");
      throw "An error occurred during the request.";
    }
  }
}
