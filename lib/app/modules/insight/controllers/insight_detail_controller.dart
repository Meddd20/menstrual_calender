import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:periodnpregnancycalender/app/models/detail_article_model.dart';
import 'package:periodnpregnancycalender/app/repositories/api_repo/article_repository.dart';
import 'package:periodnpregnancycalender/app/services/api_service.dart';
import 'package:periodnpregnancycalender/app/utils/storage_service.dart';

class InsightDetailController extends GetxController {
  final ApiService apiService = ApiService();
  late final ArticleRepository articleRepository = ArticleRepository(apiService);
  late int? id;
  final TextEditingController textEditingController = TextEditingController();
  final storageService = StorageService();
  late Stream<void> articleStream;
  var parentCommentId = 0.obs;
  var articleId = 0.obs;
  var commentContent = "".obs;
  var commentUsername = "".obs;
  var usernameId = 0.obs;
  var commentId = 0.obs;
  var isLoading = RxBool(true);
  var isReplyingComment = RxBool(false);
  late Article? data;
  RxList<Comment> comment = <Comment>[].obs;
  RxMap<int, bool> showRepliesMap = RxMap<int, bool>();
  FocusNode focusNode = FocusNode();
  

  final StreamController<String> _actionController = StreamController<String>();

  Stream<String> get actionStream => _actionController.stream;

  void addAction(String action) {
    _actionController.sink.add(action);
  }

  @override
  void onInit() {
    id = Get.arguments as int?;
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
    articleStream = fetchDetailArticle().asBroadcastStream();
    setCommentContent("");

    actionStream.listen((action) {
      if (action == "comment_added" || action == "comment_deleted" || action == "comment_liked") {
        updateComments();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    articleStream.drain();
    super.onClose();
  }

  int getParentCommentId() => parentCommentId.value;
  void setParentCommentId(int id) {
    parentCommentId.value = id;
    update();
  }

  int getArticleId() => articleId.value;
  void setArticleId(int id) {
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

  int getUsernameId() => usernameId.value;
  void setUsernameId(int id) {
    usernameId.value = id;
    update();
  }

  int getCommentId() => commentId.value;
  void setCommentId(int id) {
    commentId.value = id;
    update();
  }

  void cancelCommentReply() {
    setCommentUsername("");
    isReplyingComment.value = false;
    setParentCommentId(0);
  }

  void toggleRepliesVisibility(int index) {
    showRepliesMap[index] = !(showRepliesMap[index] ?? false);
    update();
  }

  bool isRepliesVisible(int index) {
    return showRepliesMap[index] ?? false;
  }

  void updateComments() async {
    var articleData = await articleRepository.getArticle(id ?? 0);
    data = articleData?.data.article;
    comment.assignAll(articleData?.data.comments ?? []);
    update();
  }

  Stream<void> fetchDetailArticle() async* {
    var articleData = await articleRepository.getArticle(id ?? 0);
    data = articleData?.data.article;
    comment.assignAll(articleData?.data.comments ?? []);
    update();
  }

  Future<void> storeComment() async {
    try {
      await articleRepository.storeComment(getParentCommentId(), getArticleId(), getCommentContent());
      setCommentContent("");
      addAction("comment_added");
      update();
    } catch (e) {
      print("Error store comment: $e");
    }
  }

  Future<void> likeComment(bool isLiked, int commentId) async {
    try {
      await articleRepository.likeComment(getCommentId());
      addAction("comment_liked");
      update();
    } catch (e) {
      print("Error like comment: $e");
    }
  }

  Future<void> deleteComment(int id) async {
    try {
      await articleRepository.deleteComment(id);
      addAction("comment_deleted");
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
