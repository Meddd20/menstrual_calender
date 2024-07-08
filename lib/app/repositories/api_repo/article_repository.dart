import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:periodnpregnancycalender/app/common/widgets.dart';
import 'package:periodnpregnancycalender/app/models/article_model.dart' as ArticleModel;
import 'package:periodnpregnancycalender/app/models/detail_article_model.dart' as DetailArticleModel;
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class ArticleRepository {
  final ApiService apiService;
  final Logger _logger = Logger();

  ArticleRepository(this.apiService);

  Future<ArticleModel.Article?> getAllArticle(String? tags) async {
    try {
      http.Response response = await apiService.getAllArticle(tags);

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = jsonDecode(response.body)["data"];
        final List<ArticleModel.Articles> articles = articlesJson.map<ArticleModel.Articles>((articleJson) => ArticleModel.Articles.fromJson(articleJson)).toList();

        return ArticleModel.Article(articles: articles);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get all article: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get all article: $e");
      rethrow;
    }
  }

  Future<DetailArticleModel.ArticleData?> getArticle(int id) async {
    try {
      http.Response response = await apiService.getArticle(id);

      if (response.statusCode == 200) {
        var decodedJson = json.decode(response.body.toString().replaceAll("\n", ""));
        var articleData = DetailArticleModel.ArticleData.fromJson(decodedJson);
        return articleData;
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during get article details: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during get article details: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> storeComment(int? parentId, int articleId, String content) async {
    try {
      http.Response response = await apiService.storeComment(parentId, articleId, content);

      if (response.statusCode == 200) {
        Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
        return jsonDecode(response.body);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during store comment: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during store comment: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> likeComment(int userId, int commentId) async {
    try {
      http.Response response = await apiService.likeComment(userId, commentId);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during like comment: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during like comment: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteComment(int id) async {
    try {
      http.Response response = await apiService.deleteComment(id);

      if (response.statusCode == 200) {
        Get.showSnackbar(Ui.SuccessSnackBar(message: jsonDecode(response.body)["message"]));
        return jsonDecode(response.body);
      } else {
        var errorMessage = jsonDecode(response.body)["message"] ?? "Unknown error occurred";
        Get.showSnackbar(Ui.ErrorSnackBar(message: errorMessage));
        _logger.e("Error during delete comment: $errorMessage");
        throw Exception(errorMessage);
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "An error occurred. Please try again later."));
      _logger.e("Error during delete comment: $e");
      rethrow;
    }
  }
}
