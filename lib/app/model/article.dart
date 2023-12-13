class Article {
  String id;
  String writter;
  String titleInd;
  String titleEng;
  String slugTitleInd;
  String slugTitleEng;
  String banner;
  String contentInd;
  String contentEng;
  String videoLink;
  String source;
  String tags;
  DateTime? publishAt;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  Article({
    required this.id,
    required this.writter,
    required this.titleInd,
    required this.titleEng,
    required this.slugTitleInd,
    required this.slugTitleEng,
    required this.banner,
    required this.contentInd,
    required this.contentEng,
    required this.videoLink,
    required this.source,
    required this.tags,
    this.publishAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  static Article fromJson(json) => Article(
        id: json['id'],
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
        publishAt: json['publish_at'] != null
            ? DateTime.parse(json['publish_at'])
            : null,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
      );
}
