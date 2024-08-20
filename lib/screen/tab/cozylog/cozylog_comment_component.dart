import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

class CozyLogCommentComponent extends StatefulWidget {
  CozyLogCommentComponent({
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
  State<CozyLogCommentComponent> createState() =>
      _CozyLogCommentComponentState();
}

class _CozyLogCommentComponentState extends State<CozyLogCommentComponent> {
  bool isMyComment = false;
  int userId = -1;
  final tokenManager = TokenManager.TokenManager();

  void setIsMyComment() async {
    if (widget.comment.writerId == userId) {
      setState(() {
        isMyComment = true;
      });
    }
  }

  void initUserId() async {
    userId = await tokenManager.getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initUserId();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    setIsMyComment();

    DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppUtils.scaleSize(context, 8),
        vertical: AppUtils.scaleSize(context, 15),
      ),
      child: Column(
        children: [
          !widget.comment.isDeleted
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
                          child: widget.comment.writerImageUrl == null
                              ? Image.asset(
                                  "assets/images/icons/momProfile.png")
                              : Image.network(
                                  widget.comment.writerImageUrl!,
                                  height: 50,
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
                                widget.comment.writerNickname,
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
                                widget.comment.content,
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
                                    dateFormat.format(widget.comment.createdAt),
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
                                    onTap: widget.onReply,
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
                    widget.isMyCozyLog || isMyComment
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
                                                        widget.onCommentUpdate(
                                                            widget.comment);
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
                                                          context,
                                                          widget.cozyLog
                                                              .cozyLogId!,
                                                          widget.comment
                                                              .commentId,
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
                                                        widget
                                                            .requestCommentsUpdate();
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
                                                        widget.onReply;
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
                                                          context,
                                                          widget.cozyLog
                                                              .cozyLogId!,
                                                          widget.comment
                                                              .commentId,
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
                                                        widget
                                                            .requestCommentsUpdate();
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
                                            child: Center(
                                                child: Text(
                                              "취소",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 16),
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
          widget.subComments.isNotEmpty
              ? SizedBox(
                  height: AppUtils.scaleSize(context, 20),
                )
              : const SizedBox(),
          widget.subComments.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                      left: AppUtils.scaleSize(context, 50)), // 왼쪽 패딩으로 인덴트 조정
                  child: Column(
                    children: widget.subComments.map((subComment) {
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
                                          child: subComment.writerImageUrl ==
                                                  null
                                              ? Image.asset(
                                                  "assets/images/icons/momProfile.png")
                                              : Image.network(
                                                  subComment.writerImageUrl!,
                                                  height: 50,
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
                                                      widget.comment.createdAt),
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
                                    widget.isMyCozyLog ||
                                            subComment.writerId == userId
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
                                                          child: subComment
                                                                      .writerId ==
                                                                  userId
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
                                                                            widget.onCommentUpdate(subComment);
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
                                                                              context,
                                                                              widget.cozyLog.cozyLogId!,
                                                                              subComment.commentId,
                                                                            );

                                                                            await Fluttertoast.showToast(
                                                                                msg: "댓글이 삭제되었습니다.",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                                                textColor: Colors.white,
                                                                                fontSize: AppUtils.scaleSize(context, 16));

                                                                            widget.requestCommentsUpdate();
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
                                                                            widget.onReply;
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
                                                                              context,
                                                                              widget.cozyLog.cozyLogId!,
                                                                              subComment.commentId,
                                                                            );

                                                                            await Fluttertoast.showToast(
                                                                                msg: "댓글이 삭제되었습니다.",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                                                textColor: Colors.white,
                                                                                fontSize: AppUtils.scaleSize(context, 16));
                                                                            widget.requestCommentsUpdate();
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
                                                            child: Center(
                                                                child: Text(
                                                              "취소",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: AppUtils
                                                                    .scaleSize(
                                                                        context,
                                                                        16),
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
