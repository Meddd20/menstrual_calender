import 'package:periodnpregnancycalender/app/model/article.dart';

class ArticleService {
  static List<Article> getArticles() {
    const data = [
      {
        "status": "success",
        "message": "Article retrieved successfully",
        "articles": [
          {
            "id": "42950d29-e354-46f1-8ce2-952d36a7be38",
            "writter": "John Doe",
            "title_ind": "The Importance of Menstrual Health",
            "title_eng": "Understanding Menstrual Health",
            "slug_title_ind": "importance-of-menstrual-health",
            "slug_title_eng": "understanding-menstrual-health",
            "banner": "https://example.com/menstrual-health-banner.jpg",
            "content_ind":
                """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Amet nisl purus in mollis nunc sed. Sapien eget mi proin sed libero enim sed faucibus turpis. Nulla pharetra diam sit amet nisl suscipit adipiscing bibendum est. Turpis massa tincidunt dui ut ornare lectus. Urna neque viverra justo nec ultrices dui sapien eget. Porttitor leo a diam sollicitudin tempor id. Amet mauris commodo quis imperdiet massa tincidunt nunc pulvinar sapien. In tellus integer feugiat scelerisque. Consequat id porta nibh venenatis cras sed felis eget. Cursus eget nunc scelerisque viverra. Mauris cursus mattis molestie a iaculis at erat pellentesque. Pellentesque id nibh tortor id. Vitae turpis massa sed elementum tempus. In aliquam sem fringilla ut morbi tincidunt. Blandit turpis cursus in hac habitasse platea.

Eleifend donec pretium vulputate sapien nec. Porttitor lacus luctus accumsan tortor posuere. Scelerisque varius morbi enim nunc faucibus a pellentesque. Pellentesque dignissim enim sit amet. Nec ultrices dui sapien eget mi proin sed. Id aliquet risus feugiat in ante metus dictum at. In vitae turpis massa sed. Nulla facilisi cras fermentum odio. Libero id faucibus nisl tincidunt. Odio aenean sed adipiscing diam donec adipiscing tristique risus. Est sit amet facilisis magna etiam tempor. Malesuada fames ac turpis egestas maecenas pharetra. Amet luctus venenatis lectus magna fringilla. Rhoncus aenean vel elit scelerisque mauris pellentesque. Orci eu lobortis elementum nibh tellus molestie nunc non blandit. Fames ac turpis egestas integer eget aliquet. Faucibus purus in massa tempor nec feugiat nisl pretium fusce. Blandit turpis cursus in hac habitasse platea. Nisl nunc mi ipsum faucibus vitae aliquet nec ullamcorper. Ultricies leo integer malesuada nunc vel risus commodo viverra maecenas.

Non odio euismod lacinia at quis. Euismod in pellentesque massa placerat duis ultricies lacus sed. Imperdiet dui accumsan sit amet. Sagittis aliquam malesuada bibendum arcu vitae elementum. Tincidunt arcu non sodales neque sodales ut etiam sit amet. Sollicitudin ac orci phasellus egestas tellus rutrum tellus pellentesque. Consectetur libero id faucibus nisl tincidunt eget nullam non. Dolor purus non enim praesent elementum facilisis leo. Adipiscing elit ut aliquam purus sit amet luctus venenatis lectus. Suspendisse ultrices gravida dictum fusce. Risus viverra adipiscing at in tellus integer. Viverra adipiscing at in tellus integer feugiat scelerisque varius.

Montes nascetur ridiculus mus mauris vitae ultricies leo. Vel facilisis volutpat est velit. Quisque sagittis purus sit amet volutpat consequat. Tellus rutrum tellus pellentesque eu tincidunt tortor. Dui vivamus arcu felis bibendum ut tristique. Mus mauris vitae ultricies leo integer. Amet nisl suscipit adipiscing bibendum est ultricies integer. Quisque non tellus orci ac. Luctus venenatis lectus magna fringilla urna porttitor rhoncus. Arcu vitae elementum curabitur vitae nunc sed velit dignissim sodales. At erat pellentesque adipiscing commodo elit at imperdiet. Fermentum posuere urna nec tincidunt praesent. Eget sit amet tellus cras adipiscing enim. Felis eget nunc lobortis mattis aliquam. Ac tincidunt vitae semper quis lectus nulla at volutpat. Pharetra pharetra massa massa ultricies. Dictumst quisque sagittis purus sit amet volutpat consequat mauris nunc. Et leo duis ut diam quam nulla porttitor massa id.

Rhoncus est pellentesque elit ullamcorper dignissim cras. Turpis egestas integer eget aliquet. Pulvinar etiam non quam lacus. Platea dictumst quisque sagittis purus sit amet volutpat consequat. Egestas congue quisque egestas diam. Dolor sit amet consectetur adipiscing elit ut aliquam purus sit. Eget velit aliquet sagittis id consectetur purus ut faucibus pulvinar. Nulla facilisi nullam vehicula ipsum a arcu cursus vitae congue. Commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend donec. Diam quis enim lobortis scelerisque. Ultrices in iaculis nunc sed augue lacus viverra vitae congue. Aliquet bibendum enim facilisis gravida neque convallis a cras semper. Elit ullamcorper dignissim cras tincidunt lobortis. Aliquet bibendum enim facilisis gravida neque. Egestas dui id ornare arcu odio. Mattis molestie a iaculis at erat pellentesque adipiscing. Viverra vitae congue eu consequat ac felis. Lectus sit amet est placerat. Curabitur vitae nunc sed velit dignissim. Nulla malesuada pellentesque elit eget gravida cum sociis natoque.
""",
            "content_eng":
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            "video_link": "https://www.youtube.com/watch?v=example",
            "source":
                """Doe, J. et al. (2023). Title of the Article. New England Journal of Medicine, 10(2), 123-145. 
            Smith, A. et al. (2023). Another Title of the Article. Journal of Clinical Psychology, 15(4), 567-589.
            """,
            "tags": "Menstruation",
            "publish_at": null,
            "created_at": "2023-11-03T03:23:13.000000Z",
            "updated_at": "2023-11-03T03:23:13.000000Z",
            "deleted_at": null
          },
          {
            "id": "6a9de98a-21b3-42c2-acd6-47a21632b3eb",
            "writter": "bbb",
            "title_ind": "ewgew",
            "title_eng": "aaewgegwewa",
            "slug_title_ind": "aagewga",
            "slug_title_eng": "aaewgega",
            "banner": "agwegewgaa",
            "content_ind": "aaga",
            "content_eng": "aeewgwgaa",
            "video_link": "aagewga",
            "source": "aewgewgewaa",
            "tags": "Menstruation",
            "publish_at": null,
            "created_at": "2023-10-25T15:55:09.000000Z",
            "updated_at": "2023-10-27T06:12:58.000000Z",
            "deleted_at": null
          },
          {
            "id": "85e3a1da-8a01-4f65-ba4e-d3fd13d09012",
            "writter": "bbb",
            "title_ind": "ewgew",
            "title_eng": "aaewgegwewa",
            "slug_title_ind": "aagewga",
            "slug_title_eng": "aaewgega",
            "banner": "agwegewgaa",
            "content_ind": "aaga",
            "content_eng": "aeewgwgaa",
            "video_link": "aagewga",
            "source": "aewgewgewaa",
            "tags": "Ovulation",
            "publish_at": null,
            "created_at": "2023-11-03T03:08:12.000000Z",
            "updated_at": "2023-11-03T03:08:58.000000Z",
            "deleted_at": null
          }
        ]
      }
    ];
    final articlesJson = data[0]['articles'] as List<dynamic>;
    return articlesJson
        .map((articleJson) => Article.fromJson(articleJson))
        .toList();
  }
}
