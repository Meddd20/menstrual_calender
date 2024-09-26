import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:like_button/like_button.dart';
import 'package:periodnpregnancycalender/app/common/colors.dart';
import 'package:periodnpregnancycalender/app/common/styles.dart';
import 'package:periodnpregnancycalender/app/modules/insight/controllers/insight_detail_controller.dart';
import 'package:periodnpregnancycalender/app/utils/api_endpoints.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:periodnpregnancycalender/app/utils/helpers.dart';

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
                    return Obx(
                      () {
                        return CustomScrollView(
                          slivers: [
                            SliverAppBar.large(
                              backgroundColor: Color(0xFFf9f8fb),
                              surfaceTintColor: Color(0xFFf9f8fb),
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                                child: Text(
                                  controller.data?.titleEng ?? "",
                                  style: CustomTextStyle.extraBold(22),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                              elevation: 4,
                            ),
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 0),
                              sliver: SliverToBoxAdapter(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${controller.data?.writter ?? ""} - ",
                                                style: CustomTextStyle.medium(15, height: 1.75),
                                              ),
                                              TextSpan(
                                                text: controller.getTagTranslations(context)[controller.data?.tags],
                                                style: CustomTextStyle.semiBold(15, color: Colors.blue, height: 1.75),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Text(
                                          formatLongDateTime("${controller.data?.createdAt}"),
                                          style: CustomTextStyle.medium(14, height: 1.75, color: AppColors.black.withOpacity(0.6)),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          width: Get.width,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                          child: Image.network('${ApiEndPoints.baseUrl}/${controller.data?.banner}'),
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          controller.data?.contentInd ?? "",
                                          textAlign: TextAlign.left,
                                          style: CustomTextStyle.regular(16, height: 1.75),
                                        ),
                                        SizedBox(height: 10.h),
                                        if (controller.data?.source != "") ...[
                                          Text(
                                            AppLocalizations.of(context)!.references,
                                            textAlign: TextAlign.left,
                                            style: CustomTextStyle.extraBold(20, height: 1.75),
                                          ),
                                          Text(
                                            controller.data?.source ?? "",
                                            textAlign: TextAlign.left,
                                            style: CustomTextStyle.regular(16, height: 1.75),
                                          ),
                                        ],
                                        SizedBox(height: 10.h),
                                        Text(
                                          AppLocalizations.of(context)!.comments("(${controller.comment.length})"),
                                          textAlign: TextAlign.left,
                                          style: CustomTextStyle.extraBold(20, height: 1.75),
                                        ),
                                        SizedBox(height: 5.h),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: controller.comment.length,
                                          itemBuilder: (context, index) {
                                            final comment = controller.comment[index];
                                            final commentReply = comment.children;
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onLongPress: () {
                                                    var accountId = box.read('loginId');
                                                    if (accountId == comment.userId) {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Wrap(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                        controller.deleteComment(comment.id ?? 0);
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
                                                                                AppLocalizations.of(context)!.deleteComment,
                                                                                style: CustomTextStyle.bold(14),
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
                                                      ).then((value) {
                                                        controller.focusNode.unfocus();
                                                      });
                                                    }
                                                  },
                                                  onTap: () {
                                                    controller.isReplyingComment.value = true;
                                                    controller.setParentCommentId(comment.id ?? 0);
                                                    controller.setCommentUsername(comment.username ?? "");
                                                    controller.focusNode.requestFocus();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "${comment.username ?? ""}",
                                                              style: CustomTextStyle.extraBold(16, height: 1.5),
                                                            ),
                                                            Text(
                                                              comment.content ?? "",
                                                              maxLines: 3,
                                                              textAlign: TextAlign.left,
                                                              style: CustomTextStyle.medium(16, height: 1.5),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${controller.formatDateTime(comment.createdAt ?? "")}   ",
                                                                  style: CustomTextStyle.medium(13, height: 1.5, color: AppColors.black.withOpacity(0.5)),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    controller.isReplyingComment.value = true;
                                                                    controller.setParentCommentId(comment.id ?? 0);
                                                                    controller.setCommentUsername(comment.username ?? "");
                                                                    controller.focusNode.requestFocus();
                                                                  },
                                                                  child: Text(
                                                                    AppLocalizations.of(context)!.reply,
                                                                    style: CustomTextStyle.extraBold(14, height: 1.5, color: AppColors.black.withOpacity(0.5)),
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
                                                          onTap: ((isLiked) async {
                                                            bool? isCommentLiked = comment.is_liked_by_active_user;
                                                            controller.setUsernameId(comment.userId ?? 0);
                                                            controller.setArticleId(comment.articleId ?? 0);
                                                            controller.setCommentId(comment.id ?? 0);
                                                            controller.likeComment(isLiked, comment.id ?? 0);
                                                            return isCommentLiked != null ? !isCommentLiked : false;
                                                          }),
                                                          countPostion: CountPostion.bottom,
                                                          likeCount: comment.likes,
                                                          size: 25,
                                                          circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                                          bubblesColor: BubblesColor(
                                                            dotPrimaryColor: Color(0xff33b5e5),
                                                            dotSecondaryColor: Color(0xff0099cc),
                                                          ),
                                                          isLiked: comment.is_liked_by_active_user,
                                                          likeCountAnimationDuration: Duration(milliseconds: 3000),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Obx(
                                                  () => Visibility(
                                                    visible: comment.children != null && comment.children!.isNotEmpty,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            controller.toggleRepliesVisibility(index);
                                                          },
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                WidgetSpan(
                                                                  child: SizedBox(
                                                                    width: 20,
                                                                    child: Divider(
                                                                      color: Colors.black,
                                                                      thickness: 1,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: controller.isRepliesVisible(index) ? AppLocalizations.of(context)!.hideReplies : AppLocalizations.of(context)!.viewReplies("${comment.children?.length}"),
                                                                  style: CustomTextStyle.medium(14, height: 1.5, color: AppColors.black.withOpacity(0.5)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        if (controller.isRepliesVisible(index))
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemCount: commentReply?.length,
                                                            itemBuilder: ((context, index) {
                                                              var reply = commentReply?[index];
                                                              return InkWell(
                                                                onLongPress: () {
                                                                  var accountId = box.read('loginId');
                                                                  if (accountId == reply?.userId) {
                                                                    showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return Wrap(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                                                                      controller.deleteComment(reply?.id ?? 0);
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
                                                                                              AppLocalizations.of(context)!.deleteComment,
                                                                                              style: CustomTextStyle.bold(14),
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
                                                                    ).then((value) {
                                                                      controller.focusNode.unfocus();
                                                                    });
                                                                  }
                                                                },
                                                                onTap: () {
                                                                  controller.isReplyingComment.value = true;
                                                                  controller.setParentCommentId(comment.id ?? 0);
                                                                  controller.setCommentUsername(comment.username ?? "");
                                                                  controller.focusNode.requestFocus();
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(width: 30),
                                                                    Expanded(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(height: 10),
                                                                          Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text(
                                                                                "${reply?.username ?? ""}",
                                                                                style: CustomTextStyle.extraBold(16, height: 1.5),
                                                                              ),
                                                                              Icon(Icons.arrow_right_rounded),
                                                                              if (reply?.parentCommentUserUsername != null)
                                                                                Text(
                                                                                  "${reply?.parentCommentUserUsername ?? ""}",
                                                                                  style: CustomTextStyle.extraBold(16, height: 1.5),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                          Text(
                                                                            reply?.content ?? "",
                                                                            maxLines: 3,
                                                                            textAlign: TextAlign.left,
                                                                            style: CustomTextStyle.medium(16, height: 1.5),
                                                                          ),
                                                                          SizedBox(height: 5),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "${controller.formatDateTime(reply?.createdAt ?? "")}   ",
                                                                                style: CustomTextStyle.medium(13, height: 1.5, color: AppColors.black.withOpacity(0.5)),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  controller.isReplyingComment.value = true;
                                                                                  controller.setParentCommentId(comment.id ?? 0);
                                                                                  controller.setCommentUsername(comment.username ?? "");
                                                                                  controller.focusNode.requestFocus();
                                                                                },
                                                                                child: Text(
                                                                                  AppLocalizations.of(context)!.reply,
                                                                                  style: CustomTextStyle.extraBold(14, height: 1.5, color: AppColors.black.withOpacity(0.5)),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10)
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 30,
                                                                      child: LikeButton(
                                                                        onTap: ((isLiked) async {
                                                                          bool? isCommentLiked = reply?.is_liked_by_active_user;
                                                                          controller.setUsernameId(reply?.userId ?? 0);
                                                                          controller.setCommentId(reply?.id ?? 0);
                                                                          controller.likeComment(isLiked, reply?.id ?? 0);
                                                                          return isCommentLiked != null ? !isCommentLiked : false;
                                                                        }),
                                                                        countPostion: CountPostion.bottom,
                                                                        likeCount: reply?.likes,
                                                                        size: 25,
                                                                        circleColor: CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                                                        bubblesColor: BubblesColor(
                                                                          dotPrimaryColor: Color(0xff33b5e5),
                                                                          dotSecondaryColor: Color(0xff0099cc),
                                                                        ),
                                                                        isLiked: reply?.is_liked_by_active_user,
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
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(height: 90.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
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
                        visible: controller.isReplyingComment.value && controller.storageService.getAccountId() != null,
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
                                  AppLocalizations.of(context)!.replyToComment("${controller.getCommentUsername()}"),
                                  style: CustomTextStyle.semiBold(14, height: 1.5, color: AppColors.black.withOpacity(0.5)),
                                ),
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
                      Visibility(
                        visible: controller.storageService.getCredentialToken() != null,
                        child: Container(
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
                              hintText: AppLocalizations.of(context)!.leaveYourThoughts,
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 16.0),
                              suffixIcon: controller.commentContent.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        controller.setArticleId(controller.data?.id ?? 0);
                                        controller.storeComment();
                                        controller.textEditingController.clear();
                                        controller.isReplyingComment.value = false;
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
