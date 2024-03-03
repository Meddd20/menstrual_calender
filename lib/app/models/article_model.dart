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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (articles != null) {
      data['articles'] = articles?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  String? id;
  String? writter;
  String? titleInd;
  String? titleEng;
  String? slugTitleInd;
  String? slugTitleEng;
  String? banner;
  String? contentInd;
  String? contentEng;
  String? videoLink;
  String? source;
  String? tags;
  dynamic publishAt;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Articles(
      {this.id,
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
      this.deletedAt});

  Articles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    writter = json['writter'];
    titleInd = json['title_ind'];
    titleEng = json['title_eng'];
    slugTitleInd = json['slug_title_ind'];
    slugTitleEng = json['slug_title_eng'];
    banner = json['banner'];
    contentInd = json['content_ind'];
    contentEng = json['content_eng'];
    videoLink = json['video_link'];
    source = json['source'];
    tags = json['tags'];
    publishAt = json['publish_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['writter'] = writter;
    data['title_ind'] = titleInd;
    data['title_eng'] = titleEng;
    data['slug_title_ind'] = slugTitleInd;
    data['slug_title_eng'] = slugTitleEng;
    data['banner'] = banner;
    data['content_ind'] = contentInd;
    data['content_eng'] = contentEng;
    data['video_link'] = videoLink;
    data['source'] = source;
    data['tags'] = tags;
    data['publish_at'] = publishAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
