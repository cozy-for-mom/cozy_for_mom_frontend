import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CozyLogCommentComponent extends StatelessWidget {
  const CozyLogCommentComponent({
    super.key,
    required this.cozyLog,
    required this.comment,
    required this.subComments,
    required this.onReply,
    required this.isMyCozyLog,
    required this.requestCommentsUpdate,
    required this.onCommentUpdate,
  });

  final CozyLog cozyLog;
  final CozyLogComment comment;
  final List<CozyLogComment> subComments;
  final Function() onReply;
  final Function() requestCommentsUpdate;
  final Function(CozyLogComment comment) onCommentUpdate;
  final bool isMyCozyLog;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');
    bool isMyComment = comment.writerId == 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppUtils.scaleSize(context, 8),
        vertical: AppUtils.scaleSize(context, 15),
      ),
      child: Column(
        children: [
          !comment.isDeleted
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: AppUtils.scaleSize(context, 50),
                          child: comment.writerImageUrl == null
                              ? Image.asset(
                                  "assets/images/icons/momProfile.png")
                              : Image.network(
                                  comment.writerImageUrl!,
                                ),
                        ),
                        SizedBox(
                          width: AppUtils.scaleSize(context, 12),
                        ),
                        SizedBox(
                          height: AppUtils.scaleSize(context, 70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.writerNickname,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppUtils.scaleSize(context, 14),
                                ),
                              ),
                              SizedBox(
                                height: AppUtils.scaleSize(context, 5),
                              ),
                              Text(
                                comment.content,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppUtils.scaleSize(context, 14),
                                ),
                              ),
                              SizedBox(
                                height: AppUtils.scaleSize(context, 5),
                              ),
                              Row(
                                children: [
                                  Text(
                                    dateFormat.format(comment.createdAt),
                                    style: TextStyle(
                                      color: const Color(0xffAAAAAA),
                                      fontWeight: FontWeight.w500,
                                      fontSize: AppUtils.scaleSize(context, 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppUtils.scaleSize(context, 7),
                                  ),
                                  InkWell(
                                    onTap: onReply,
                                    child: Text(
                                      "답글쓰기",
                                      style: TextStyle(
                                        color: const Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppUtils.scaleSize(context, 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    isMyCozyLog || isMyComment
                        ? IconButton(
                            icon: const Icon(
                              Icons.more_vert_outlined,
                              color: Color(0xff858998),
                            ),
                            onPressed: () {
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: AppUtils.scaleSize(context, 220),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: screenWidth -
                                              AppUtils.scaleSize(context, 40),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                          child: isMyComment
                                              ? Center(
                                                  child:
                                                      Column(children: <Widget>[
                                                    ListTile(
                                                      title: const Center(
                                                          child: Text(
                                                        '수정하기',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      onTap: () {
                                                        onCommentUpdate(
                                                            comment);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: const Center(
                                                          child: Text(
                                                        '삭제하기',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await CozyLogCommentApiService()
                                                            .deleteComment(
                                                          cozyLog.cozyLogId!,
                                                          comment.commentId,
                                                        );

                                                        await Fluttertoast.showToast(
                                                            msg: "댓글이 삭제되었습니다.",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.7),
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    16));
                                                        requestCommentsUpdate();
                                                      },
                                                    ),
                                                  ]),
                                                )
                                              : Center(
                                                  child:
                                                      Column(children: <Widget>[
                                                    ListTile(
                                                      title: const Center(
                                                          child: Text(
                                                        '답글',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      onTap: () {
                                                        onReply;
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: const Center(
                                                          child: Text(
                                                        '댓글 삭제하기',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                      onTap: () async {
                                                        Navigator.pop(context);
                                                        await CozyLogCommentApiService()
                                                            .deleteComment(
                                                          cozyLog.cozyLogId!,
                                                          comment.commentId,
                                                        );

                                                        await Fluttertoast.showToast(
                                                            msg: "댓글이 삭제되었습니다.",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.7),
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    16));
                                                        requestCommentsUpdate();
                                                      },
                                                    ),
                                                  ]),
                                                ),
                                        ),
                                        SizedBox(
                                          height:
                                              AppUtils.scaleSize(context, 20),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: screenWidth -
                                                AppUtils.scaleSize(context, 40),
                                            height:
                                                AppUtils.scaleSize(context, 56),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: const Color(0xffC2C4CB),
                                            ),
                                            child: const Center(
                                                child: Text(
                                              "취소",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Container(),
                  ],
                )
              : Container(
                  child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("댓글이 삭제되었습니다.")),
                ),
          subComments.isNotEmpty
              ? SizedBox(
                  height: AppUtils.scaleSize(context, 20),
                )
              : const SizedBox(),
          subComments.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      left: AppUtils.scaleSize(context, 50)), // 왼쪽 패딩으로 인덴트 조정
                  child: Column(
                    children: subComments.map((subComment) {
                      return Column(
                        children: [
                          SizedBox(
                            height: AppUtils.scaleSize(context, 10),
                          ),
                          !subComment.isDeleted
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          height:
                                              AppUtils.scaleSize(context, 50),
                                          child: comment.writerImageUrl == null
                                              ? Image.asset(
                                                  "assets/images/icons/momProfile.png")
                                              : Image.network(
                                                  comment.writerImageUrl!,
                                                ),
                                        ),
                                        SizedBox(
                                          width:
                                              AppUtils.scaleSize(context, 12),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subComment.writerNickname,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 14),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 5),
                                            ),
                                            Text(
                                              subComment.content,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 14),
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 5),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  dateFormat.format(
                                                      comment.createdAt),
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffAAAAAA),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        AppUtils.scaleSize(
                                                            context, 12),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: AppUtils.scaleSize(
                                                      context, 7),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    isMyCozyLog || isMyComment
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.more_vert_outlined,
                                              color: Color(0xff858998),
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                    height: AppUtils.scaleSize(
                                                        context, 220),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: screenWidth -
                                                              AppUtils
                                                                  .scaleSize(
                                                                      context,
                                                                      40),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.white,
                                                          ),
                                                          child: isMyComment
                                                              ? Center(
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Center(
                                                                              child: Text(
                                                                            '수정하기',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )),
                                                                          onTap:
                                                                              () {
                                                                            onCommentUpdate(subComment);
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title: const Center(
                                                                              child: Text(
                                                                            '삭제하기',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )),
                                                                          onTap:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            await CozyLogCommentApiService().deleteComment(
                                                                              cozyLog.cozyLogId!,
                                                                              comment.commentId,
                                                                            );

                                                                            await Fluttertoast.showToast(
                                                                                msg: "댓글이 삭제되었습니다.",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                                                textColor: Colors.white,
                                                                                fontSize: AppUtils.scaleSize(context, 16));

                                                                            requestCommentsUpdate();
                                                                          },
                                                                        ),
                                                                      ]),
                                                                )
                                                              : Center(
                                                                  child: Column(
                                                                      children: <Widget>[
                                                                        ListTile(
                                                                          title: const Center(
                                                                              child: Text(
                                                                            '답글',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )),
                                                                          onTap:
                                                                              () {
                                                                            onReply;
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          title: const Center(
                                                                              child: Text(
                                                                            '삭제하기',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )),
                                                                          onTap:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            await CozyLogCommentApiService().deleteComment(
                                                                              cozyLog.cozyLogId!,
                                                                              comment.commentId,
                                                                            );

                                                                            await Fluttertoast.showToast(
                                                                                msg: "댓글이 삭제되었습니다.",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                                                textColor: Colors.white,
                                                                                fontSize: AppUtils.scaleSize(context, 16));
                                                                            requestCommentsUpdate();
                                                                          },
                                                                        ),
                                                                      ]),
                                                                ),
                                                        ),
                                                        SizedBox(
                                                          height: AppUtils
                                                              .scaleSize(
                                                                  context, 20),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: screenWidth -
                                                                AppUtils
                                                                    .scaleSize(
                                                                        context,
                                                                        40),
                                                            height: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    56),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              color: const Color(
                                                                  0xffC2C4CB),
                                                            ),
                                                            child: const Center(
                                                                child: Text(
                                                              "취소",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            )),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(
                                  child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("댓글이 삭제되었습니다.")),
                                ),
                        ],
                      );
                    }).toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
