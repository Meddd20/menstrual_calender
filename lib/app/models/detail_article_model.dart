class ArticleData {
  final String status;
  final String message;
  final ArticleDetails data;

  ArticleData({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    return ArticleData(
      status: json['status'],
      message: json['message'],
      data: ArticleDetails.fromJson(json['data']),
    );
  }
}

class ArticleDetails {
  final Article article;
  final List<Comment>? comments;

  ArticleDetails({
    required this.article,
    required this.comments,
  });

  factory ArticleDetails.fromJson(Map<String, dynamic> json) {
    return ArticleDetails(
      article: Article.fromJson(json['article']),
      comments: (json['comments'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }
}

class Article {
  final String? id;
  final String? userId;
  final String? writter;
  final String? titleInd;
  final String? titleEng;
  final String? slugTitleInd;
  final String? slugTitleEng;
  final String? banner;
  final String? contentInd;
  final String? contentEng;
  final String? videoLink;
  final String? source;
  final String? tags;
  final dynamic publishAt;
  final String? createdAt;
  final String? updatedAt;

  Article({
    this.id,
    this.userId,
    this.writter,
    this.titleInd,
    this.titleEng,
    this.slugTitleInd,
    this.slugTitleEng,
    this.banner,
    this.contentInd,
    this.contentEng,
    this.videoLink,
    this.source,
    this.tags,
    this.publishAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      userId: json['user_id'],
      writter: json['writter'],
      titleInd: json['title_ind'],
      titleEng: json['title_eng'],
      slugTitleInd: json['slug_title_ind'],
      slugTitleEng: json['slug_title_eng'],
      banner: json['banner'],
      contentInd: json['content_ind'],
      contentEng: json['content_eng'],
      videoLink: json['video_link'],
      source: json['source'],
      tags: json['tags'],
      publishAt: json['publish_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Comment {
  final String? id;
  final String? articleId;
  final String? userId;
  final String? username;
  final String? parentId;
  final String? parentCommentUserId;
  final String? content;
  final int? likes;
  final String? isPinned;
  final String? isHidden;
  final String? createdAt;
  final String? updatedAt;
  final bool? is_liked_by_active_user;
  final List<Comment>? children;

  Comment({
    this.id,
    this.articleId,
    this.userId,
    this.username,
    this.parentId,
    this.parentCommentUserId,
    this.content,
    this.likes,
    this.isPinned,
    this.isHidden,
    this.createdAt,
    this.updatedAt,
    this.is_liked_by_active_user,
    this.children,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      articleId: json['article_id'],
      userId: json['user_id'],
      username: json['username'],
      parentId: json['parent_id'],
      parentCommentUserId: json['parent_comment_user_id'],
      content: json['content'],
      likes: json['likes'],
      isPinned: json['is_pinned'],
      isHidden: json['is_hidden'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      is_liked_by_active_user: json['is_liked_by_active_user'],
      children: json['children'] != null
          ? List<Comment>.from(json['children'].map((x) => Comment.fromJson(x)))
          : null,
    );
  }
}
