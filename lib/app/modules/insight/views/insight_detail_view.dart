import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:like_button/like_button.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/modules/insight/controllers/insight_detail_controller.dart';

class InsightDetailView extends GetView<InsightDetailController> {
  const InsightDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(InsightDetailController());
    final box = GetStorage();
    return GestureDetector(
      onTap: () {
        controller.focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFf9f8fb),
          surfaceTintColor: Color(0xFFf9f8fb),
          title: const Text('InsightDetailView'),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 1400));
            await controller.articleStream;
          },
          child: Stack(
            children: [
              StreamBuilder(
                stream: controller.articleStream,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Obx(() {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Get.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${controller.data?.banner}"),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          controller.data?.titleInd ?? "",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${controller.data?.writter ?? ""} - ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.38,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "${controller.data?.tags ?? ""}",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 13.sp,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.38,
                                                height: 2.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        controller.formatDate(
                                            controller.data?.createdAt ?? ""),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.38,
                                          height: 2.0,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        controller.data?.contentInd ?? "",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                          height: 1.7,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        "References",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.38,
                                          height: 2.0,
                                        ),
                                      ),
                                      Text(
                                        controller.data?.source ?? "",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 1.7,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        "Comments (${controller.comment.length})",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.38,
                                          height: 2.0,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      SingleChildScrollView(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: controller.comment.length,
                                          itemBuilder: (context, index) {
                                            final comment =
                                                controller.comment[index];
                                            final commentReply =
                                                comment.children;
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onLongPress: () {
                                                    var accountId =
                                                        box.read('loginId');
                                                    if (accountId ==
                                                        comment.userId) {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Wrap(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height: 4.h,
                                                                    width: 32.w,
                                                                    margin: EdgeInsets.only(
                                                                        top: 16
                                                                            .h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .blueGrey,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            3.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10.h),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        controller.deleteComment(comment.id ??
                                                                            "");
                                                                        Get.back();
                                                                        controller
                                                                            .focusNode
                                                                            .unfocus();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                16,
                                                                            right:
                                                                                16),
                                                                        height:
                                                                            50,
                                                                        width: Get
                                                                            .width,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                "Delete comment",
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              Icon(Icons.delete)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10.h),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ).then((value) {
                                                        controller.focusNode
                                                            .unfocus();
                                                      });
                                                    }
                                                  },
                                                  onTap: () {
                                                    controller.isReplyingComment
                                                        .value = true;
                                                    controller
                                                        .setParentCommentId(
                                                            comment.id ?? "");
                                                    controller
                                                        .setCommentUsername(
                                                            comment.username ??
                                                                "");
                                                    controller.focusNode
                                                        .requestFocus();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "${comment.username ?? ""}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              comment.content ??
                                                                  "",
                                                              maxLines: 3,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 1.7,
                                                              ),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${controller.formatDateTime(comment.createdAt ?? "")}   ",
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppColors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontSize:
                                                                        13.sp,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    controller
                                                                        .isReplyingComment
                                                                        .value = true;
                                                                    controller.setParentCommentId(
                                                                        comment.id ??
                                                                            "");
                                                                    controller.setCommentUsername(
                                                                        comment.username ??
                                                                            "");
                                                                    controller
                                                                        .focusNode
                                                                        .requestFocus();
                                                                  },
                                                                  child: Text(
                                                                    "Reply",
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontSize:
                                                                          13.sp,
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10)
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 30,
                                                        child: LikeButton(
                                                          onTap:
                                                              ((isLiked) async {
                                                            bool?
                                                                isCommentLiked =
                                                                comment
                                                                    .is_liked_by_active_user;
                                                            controller
                                                                .setUsernameId(
                                                                    comment.userId ??
                                                                        "");
                                                            controller.setArticleId(
                                                                comment.articleId ??
                                                                    "");
                                                            controller
                                                                .setCommentId(
                                                                    comment.id ??
                                                                        "");
                                                            controller
                                                                .likeComment(
                                                                    isLiked,
                                                                    comment.id ??
                                                                        "");
                                                            return isCommentLiked !=
                                                                    null
                                                                ? !isCommentLiked
                                                                : false;
                                                          }),
                                                          countPostion:
                                                              CountPostion
                                                                  .bottom,
                                                          likeCount:
                                                              comment.likes,
                                                          size: 25,
                                                          circleColor: CircleColor(
                                                              start: Color(
                                                                  0xff00ddff),
                                                              end: Color(
                                                                  0xff0099cc)),
                                                          bubblesColor:
                                                              BubblesColor(
                                                            dotPrimaryColor:
                                                                Color(
                                                                    0xff33b5e5),
                                                            dotSecondaryColor:
                                                                Color(
                                                                    0xff0099cc),
                                                          ),
                                                          isLiked: comment
                                                              .is_liked_by_active_user,
                                                          likeCountAnimationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      3000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: comment.children !=
                                                          null &&
                                                      comment
                                                          .children!.isNotEmpty,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          controller
                                                              .toggleRepliesVisibility(
                                                                  index);
                                                        },
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                  width: 20,
                                                                  child:
                                                                      Divider(
                                                                    color: Colors
                                                                        .black,
                                                                    thickness:
                                                                        1,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: controller
                                                                        .isRepliesVisible(
                                                                            index)
                                                                    ? '  Hide replies'
                                                                    : '  View ${comment.children?.length} replies',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      if (controller
                                                          .isRepliesVisible(
                                                              index))
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount:
                                                              commentReply
                                                                  ?.length,
                                                          itemBuilder:
                                                              ((context,
                                                                  index) {
                                                            var reply =
                                                                commentReply?[
                                                                    index];
                                                            return InkWell(
                                                              onLongPress: () {
                                                                var accountId =
                                                                    box.read(
                                                                        'loginId');
                                                                if (accountId ==
                                                                    reply
                                                                        ?.userId) {
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Wrap(
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                height: 4.h,
                                                                                width: 32.w,
                                                                                margin: EdgeInsets.only(top: 16.h),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.blueGrey,
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(3.0),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10.h),
                                                                              Padding(
                                                                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                                                child: InkWell(
                                                                                  onTap: () {
                                                                                    controller.deleteComment(reply?.id ?? "");
                                                                                    Get.back();
                                                                                    controller.focusNode.unfocus();
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.only(left: 16, right: 16),
                                                                                    height: 50,
                                                                                    width: Get.width,
                                                                                    child: Align(
                                                                                      alignment: Alignment.centerLeft,
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            "Delete comment",
                                                                                            style: TextStyle(
                                                                                              color: Colors.black,
                                                                                              fontSize: 15,
                                                                                              fontWeight: FontWeight.w500,
                                                                                            ),
                                                                                          ),
                                                                                          Icon(Icons.delete)
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10.h),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ).then(
                                                                      (value) {
                                                                    controller
                                                                        .focusNode
                                                                        .unfocus();
                                                                  });
                                                                }
                                                              },
                                                              onTap: () {
                                                                controller
                                                                    .isReplyingComment
                                                                    .value = true;
                                                                controller
                                                                    .setParentCommentId(
                                                                        comment.id ??
                                                                            "");
                                                                controller
                                                                    .setCommentUsername(
                                                                        comment.username ??
                                                                            "");
                                                                controller
                                                                    .focusNode
                                                                    .requestFocus();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width:
                                                                          30),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Text(
                                                                          "${reply?.username ?? ""}",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          reply?.content ??
                                                                              "",
                                                                          maxLines:
                                                                              3,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontFamily:
                                                                                'Poppins',
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            height:
                                                                                1.7,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                5),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              "${controller.formatDateTime(reply?.createdAt ?? "")}   ",
                                                                              style: TextStyle(
                                                                                color: AppColors.black.withOpacity(0.5),
                                                                                fontSize: 13.sp,
                                                                                fontFamily: 'Poppins',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                controller.isReplyingComment.value = true;
                                                                                controller.setParentCommentId(reply?.id ?? "");
                                                                                controller.setCommentUsername(reply?.username ?? "");
                                                                                controller.focusNode.requestFocus();
                                                                              },
                                                                              child: Text(
                                                                                "Reply",
                                                                                style: TextStyle(
                                                                                  color: AppColors.black.withOpacity(0.6),
                                                                                  fontSize: 13.sp,
                                                                                  fontFamily: 'Poppins',
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 5)
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 30,
                                                                    child:
                                                                        LikeButton(
                                                                      onTap:
                                                                          ((isLiked) async {
                                                                        bool?
                                                                            isCommentLiked =
                                                                            reply?.is_liked_by_active_user;
                                                                        controller.setUsernameId(reply?.userId ??
                                                                            "");
                                                                        controller.setCommentId(reply?.id ??
                                                                            "");
                                                                        controller.likeComment(
                                                                            isLiked,
                                                                            reply?.id ??
                                                                                "");
                                                                        return isCommentLiked !=
                                                                                null
                                                                            ? !isCommentLiked
                                                                            : false;
                                                                      }),
                                                                      countPostion:
                                                                          CountPostion
                                                                              .bottom,
                                                                      likeCount:
                                                                          reply
                                                                              ?.likes,
                                                                      size: 25,
                                                                      circleColor: CircleColor(
                                                                          start: Color(
                                                                              0xff00ddff),
                                                                          end: Color(
                                                                              0xff0099cc)),
                                                                      bubblesColor:
                                                                          BubblesColor(
                                                                        dotPrimaryColor:
                                                                            Color(0xff33b5e5),
                                                                        dotSecondaryColor:
                                                                            Color(0xff0099cc),
                                                                      ),
                                                                      isLiked: reply
                                                                          ?.is_liked_by_active_user,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                        )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 90.h),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  }
                }),
              ),
              Obx(
                () => Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    children: [
                      Visibility(
                        visible: controller.isReplyingComment.value,
                        child: Container(
                          height: 40,
                          width: Get.width,
                          color: AppColors.white,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Replying to ${controller.getCommentUsername()}\'s comment"),
                                IconButton(
                                  onPressed: () {
                                    controller.cancelCommentReply();
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.xmark,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 75.h,
                        width: Get.width,
                        color: AppColors.white,
                        padding: EdgeInsets.fromLTRB(13.w, 10.h, 13.w, 0),
                        child: TextFormField(
                          controller: controller.textEditingController,
                          onChanged: (value) {
                            controller.setCommentContent(value);
                          },
                          focusNode: controller.focusNode,
                          decoration: InputDecoration(
                            hintText: 'Leave your thoughts...',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(
                                16.0, 14.0, 16.0, 16.0),
                            suffixIcon: controller.commentContent.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      controller.setArticleId(
                                          controller.data?.id ?? "");
                                      controller.storeComment();
                                      controller.textEditingController.clear();
                                      controller.isReplyingComment.value =
                                          false;
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: Icon(Icons.send),
                                  )
                                : null,
                          ),
                          cursorColor: Colors.red,
                          cursorWidth: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
