class Article {
  String? status;
  String? message;
  List<Articles>? articles;

  Article({this.status, this.message, this.articles});

  Article.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles?.add(Articles.fromJson(v));
      });
    }
  }
}

class Articles {
  int? id;
  int? userId;
  String? writter;
  String? titleInd;
  String? titleEng;
  String? slugTitleInd;
  String? slugTitleEng;
  String? banner;
  String? contentInd;
  String? contentEng;
  String? source;
  String? tags;
  String? publishAt;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Articles(
      {this.id,
      this.userId,
      this.writter,
      this.titleInd,
      this.titleEng,
      this.slugTitleInd,
      this.slugTitleEng,
      this.banner,
      this.contentInd,
      this.contentEng,
      this.source,
      this.tags,
      this.publishAt,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Articles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    writter = json['writter'];
    titleInd = json['title_ind'];
    titleEng = json['title_eng'];
    slugTitleInd = json['slug_title_ind'];
    slugTitleEng = json['slug_title_eng'];
    banner = json['banner'];
    contentInd = json['content_ind'];
    contentEng = json['content_eng'];
    source = json['source'];
    tags = json['tags'];
    publishAt = json['publish_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
}
