import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:periodnpregnancycalender/app/models/detail_article_model.dart';
import 'package:periodnpregnancycalender/app/repositories/article_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';

class InsightDetailController extends GetxController {
  final ApiService apiService = ApiService();
  late final ArticleRepository articleRepository =
      ArticleRepository(apiService);
  late String? id;
  final TextEditingController textEditingController = TextEditingController();
  late Stream<Article?> articleStream;
  var parentCommentId = "".obs;
  var articleId = "".obs;
  var commentContent = "".obs;
  var commentUsername = "".obs;
  var usernameId = "".obs;
  var commentId = "".obs;
  var isLoading = RxBool(true);
  var isReplyingComment = RxBool(false);
  late Article? data;
  RxList<Comment> comment = <Comment>[].obs;
  Map<int, bool> showRepliesMap = {};
  FocusNode focusNode = FocusNode();

  final StreamController<String> _addCommentController =
      StreamController<String>();
  final StreamController<String> _likeCommentController =
      StreamController<String>();
  final StreamController<String> _deleteCommentController =
      StreamController<String>();

  Stream<String> get addCommentStream => _addCommentController.stream;
  Stream<String> get likeCommentStream => _likeCommentController.stream;
  Stream<String> get deleteCommentStream => _deleteCommentController.stream;

  void setAddComment(String comment) {
    _addCommentController.sink.add(comment);
  }

  void setLikeComment(String commentId) {
    _likeCommentController.sink.add(commentId);
  }

  void setDeleteComment(String commentId) {
    _deleteCommentController.sink.add(commentId);
  }

  @override
  void onInit() {
    id = Get.arguments as String?;
    data = Article(
      id: null,
      writter: null,
      titleInd: null,
      titleEng: null,
      slugTitleInd: null,
      slugTitleEng: null,
      banner: null,
      contentInd: null,
      contentEng: null,
      videoLink: null,
      source: null,
      tags: null,
      publishAt: null,
      createdAt: null,
      updatedAt: null,
    );
    articleStream = fetchArticleStream().asBroadcastStream();
    setCommentContent("");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _addCommentController.close();
    _likeCommentController.close();
    _deleteCommentController.close();
    super.onClose();
  }

  String getParentCommentId() => parentCommentId.value;
  void setParentCommentId(String id) {
    parentCommentId.value = id;
    update();
  }

  String getArticleId() => articleId.value;
  void setArticleId(String id) {
    articleId.value = id;
    update();
  }

  String getCommentContent() => commentContent.value;
  void setCommentContent(String content) {
    commentContent.value = content;
    update();
  }

  String getCommentUsername() => commentUsername.value;
  void setCommentUsername(String username) {
    commentUsername.value = username;
    update();
  }

  String getUsernameId() => usernameId.value;
  void setUsernameId(String id) {
    usernameId.value = id;
    update();
  }

  String getCommentId() => commentId.value;
  void setCommentId(String id) {
    commentId.value = id;
    update();
  }

  void cancelCommentReply() {
    setCommentUsername("");
    isReplyingComment.value = false;
    setParentCommentId("");
  }

  void toggleRepliesVisibility(int index) {
    showRepliesMap[index] = !(showRepliesMap[index] ?? false);
    update();
  }

  bool isRepliesVisible(int index) {
    return showRepliesMap[index] ?? false;
  }

  Stream<Article?> fetchArticleStream() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return articleRepository.getArticle(id ?? "");
    }).asyncMap((result) async {
      var articleData = await result;
      data = articleData?.data.article;
      comment.assignAll(articleData?.data.comments ?? []);
      return articleData?.data.article;
    });
  }

  Future<void> storeComment() async {
    try {
      await articleRepository.storeComment(
          getParentCommentId(), getArticleId(), getCommentContent());
      setCommentContent("");
      _addCommentController.sink.add("comment_added");
      update();
    } catch (e) {
      print("Error store comment: $e");
    }
  }

  Future<bool> likeComment(bool isLiked, String commentId) async {
    try {
      var data = await articleRepository.likeComment(
          getUsernameId(), getCommentId());
      _likeCommentController.sink.add("comment_liked");
      update();
      return data["data"];
    } catch (e) {
      print("Error like comment: $e");
      return false;
    }
  }

  Future<void> deleteComment(String id) async {
    try {
      await articleRepository.deleteComment(id);
      _deleteCommentController.sink.add("comment_deleted");
      update();
    } catch (e) {
      print("Error fetching articles: $e");
    }
  }

  String formatDate(String? inputDate) {
    if (inputDate != null) {
      DateTime date = DateTime.parse(inputDate);
      String formattedDate = DateFormat('EEEE, d MMMM yyyy HH:mm').format(date);
      return formattedDate;
    }
    return '';
  }

  String formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inMinutes}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays <= 1) {
      return '1 days ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 365 && date.year == now.year) {
      return '${date.day}-${date.month}';
    } else {
      return '${date.day}-${date.month}-${date.year}';
    }
  }
}
