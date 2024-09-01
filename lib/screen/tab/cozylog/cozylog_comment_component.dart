import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // height: AppUtils.scaleSize(context, 50),
                          child: widget.comment.writerImageUrl == null
                              ? Image.asset(
                                  "assets/images/icons/momProfile.png",
                                  width: AppUtils.scaleSize(context, 50),
                                  height: AppUtils.scaleSize(context, 50))
                              : ClipOval(
                                  child: Image.network(
                                      widget.comment.writerImageUrl!,
                                      fit: BoxFit.cover,
                                      width: AppUtils.scaleSize(context, 50),
                                      height: AppUtils.scaleSize(context, 50)),
                                ),
                        ),
                        SizedBox(
                          width: AppUtils.scaleSize(context, 17),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: AppUtils.scaleSize(context, 240),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.comment.writerNickname,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppUtils.scaleSize(context, 14),
                                    ),
                                  ),
                                  widget.cozyLog.writer.nickname ==
                                          widget.comment.writerNickname
                                      ? Container(
                                          width:
                                              AppUtils.scaleSize(context, 46),
                                          height:
                                              AppUtils.scaleSize(context, 19),
                                          margin: EdgeInsets.only(
                                              left: AppUtils.scaleSize(
                                                  context, 7)),
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '작성자',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: AppUtils.scaleSize(
                                                    context, 10),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: AppUtils.scaleSize(context, 5),
                            ),
                            SizedBox(
                              width: AppUtils.scaleSize(context, 250),
                              child: Text(
                                widget.comment.content,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppUtils.scaleSize(context, 14),
                                ),
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
                                      fontSize: AppUtils.scaleSize(context, 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.isMyCozyLog || isMyComment
                        ? SizedBox(
                            width: AppUtils.scaleSize(context, 3),
                            child: IconButton(
                              icon: Image(
                                image: const AssetImage(
                                    'assets/images/icons/more_vert_outlined.png'),
                                color: const Color(0xff858998),
                                width: AppUtils.scaleSize(context, 3),
                                height: AppUtils.scaleSize(context, 17),
                              ),
                              padding: EdgeInsets.zero,
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: AppUtils.scaleSize(
                                                    context, 8)),
                                            width: screenWidth -
                                                AppUtils.scaleSize(context, 40),
                                            height: AppUtils.scaleSize(
                                                context, 128),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: isMyComment
                                                ? Center(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          ListTile(
                                                            title: Center(
                                                                child: Text(
                                                              '수정하기', // TODO 공통 모달 위젯으로 변경하기
                                                              style: TextStyle(
                                                                  color:
                                                                      mainTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          16)),
                                                            )),
                                                            onTap: () {
                                                              widget.onCommentUpdate(
                                                                  widget
                                                                      .comment);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: Center(
                                                                child: Text(
                                                              '삭제하기',
                                                              style: TextStyle(
                                                                  color:
                                                                      mainTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          16)),
                                                            )),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return DeleteModal(
                                                                    title:
                                                                        '댓글이',
                                                                    text:
                                                                        '등록된 댓글을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                    tapFunc:
                                                                        () async {
                                                                      await CozyLogCommentApiService()
                                                                          .deleteComment(
                                                                        context,
                                                                        widget
                                                                            .cozyLog
                                                                            .cozyLogId!,
                                                                        widget
                                                                            .comment
                                                                            .commentId,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        widget
                                                                            .requestCommentsUpdate();
                                                                      });
                                                                    },
                                                                  );
                                                                },
                                                                barrierDismissible:
                                                                    false,
                                                              );
                                                            },
                                                          ),
                                                        ]),
                                                  )
                                                : Center(
                                                    child: Column(
                                                        children: <Widget>[
                                                          ListTile(
                                                            title: Center(
                                                                child: Text(
                                                              '답글',
                                                              style: TextStyle(
                                                                  color:
                                                                      mainTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          16)),
                                                            )),
                                                            onTap: () {
                                                              widget.onReply;
                                                            },
                                                          ),
                                                          ListTile(
                                                            title: Center(
                                                                child: Text(
                                                              '댓글 삭제하기',
                                                              style: TextStyle(
                                                                  color:
                                                                      mainTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: AppUtils
                                                                      .scaleSize(
                                                                          context,
                                                                          16)),
                                                            )),
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return DeleteModal(
                                                                    title:
                                                                        '댓글이',
                                                                    text:
                                                                        '등록된 댓글을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                    tapFunc:
                                                                        () async {
                                                                      await CozyLogCommentApiService()
                                                                          .deleteComment(
                                                                        context,
                                                                        widget
                                                                            .cozyLog
                                                                            .cozyLogId!,
                                                                        widget
                                                                            .comment
                                                                            .commentId,
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        widget
                                                                            .requestCommentsUpdate();
                                                                      });
                                                                    },
                                                                  );
                                                                },
                                                                barrierDismissible:
                                                                    false,
                                                              );
                                                            },
                                                          ),
                                                        ]),
                                                  ),
                                          ),
                                          SizedBox(
                                            height:
                                                AppUtils.scaleSize(context, 15),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: screenWidth -
                                                  AppUtils.scaleSize(
                                                      context, 40),
                                              height: AppUtils.scaleSize(
                                                  context, 56),
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
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  "assets/images/icons/momProfile.png",
                                                  fit: BoxFit.cover,
                                                  width: AppUtils.scaleSize(
                                                      context, 50),
                                                  height: AppUtils.scaleSize(
                                                      context, 50))
                                              : ClipOval(
                                                  child: Image.network(
                                                      subComment
                                                          .writerImageUrl!,
                                                      fit: BoxFit.cover,
                                                      width: AppUtils.scaleSize(
                                                          context, 50),
                                                      height:
                                                          AppUtils.scaleSize(
                                                              context, 50)),
                                                ),
                                        ),
                                        SizedBox(
                                          width:
                                              AppUtils.scaleSize(context, 17),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  subComment.writerNickname,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        AppUtils.scaleSize(
                                                            context, 14),
                                                  ),
                                                ),
                                                widget.cozyLog.writer
                                                            .nickname ==
                                                        subComment
                                                            .writerNickname
                                                    ? Container(
                                                        width:
                                                            AppUtils.scaleSize(
                                                                context, 46),
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 19),
                                                        margin: EdgeInsets.only(
                                                            left: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    7)),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '작성자',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: AppUtils
                                                                  .scaleSize(
                                                                      context,
                                                                      10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: AppUtils.scaleSize(
                                                  context, 5),
                                            ),
                                            SizedBox(
                                              width: AppUtils.scaleSize(
                                                  context, 200),
                                              child: Text(
                                                subComment.content,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: AppUtils.scaleSize(
                                                      context, 14),
                                                ),
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
                                        ? SizedBox(
                                            width:
                                                AppUtils.scaleSize(context, 3),
                                            child: IconButton(
                                              icon: Image(
                                                image: const AssetImage(
                                                    'assets/images/icons/more_vert_outlined.png'),
                                                color: const Color(0xff858998),
                                                width: AppUtils.scaleSize(
                                                    context, 3),
                                                height: AppUtils.scaleSize(
                                                    context, 17),
                                              ),
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                showModalBottomSheet<void>(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SizedBox(
                                                      height:
                                                          AppUtils.scaleSize(
                                                              context, 220),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.symmetric(
                                                                vertical: AppUtils
                                                                    .scaleSize(
                                                                        context,
                                                                        8)),
                                                            width: screenWidth -
                                                                AppUtils
                                                                    .scaleSize(
                                                                        context,
                                                                        40),
                                                            height: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    128),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: subComment
                                                                        .writerId ==
                                                                    userId
                                                                ? Center(
                                                                    child: Column(
                                                                        children: <Widget>[
                                                                          ListTile(
                                                                            title: Center(
                                                                                child: Text(
                                                                              '수정하기',
                                                                              style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: AppUtils.scaleSize(context, 16)),
                                                                            )),
                                                                            onTap:
                                                                                () {
                                                                              widget.onCommentUpdate(subComment);
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                          ListTile(
                                                                            title: Center(
                                                                                child: Text(
                                                                              '삭제하기',
                                                                              style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: AppUtils.scaleSize(context, 16)),
                                                                            )),
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return DeleteModal(
                                                                                    title: '댓글이',
                                                                                    text: '등록된 댓글을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                                    tapFunc: () async {
                                                                                      await CozyLogCommentApiService().deleteComment(
                                                                                        context,
                                                                                        widget.cozyLog.cozyLogId!,
                                                                                        subComment.commentId,
                                                                                      );
                                                                                      setState(() {
                                                                                        widget.requestCommentsUpdate();
                                                                                      });
                                                                                    },
                                                                                  );
                                                                                },
                                                                                barrierDismissible: false,
                                                                              );
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
                                                                              style: TextStyle(
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
                                                                              '댓글 삭제하기',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            )),
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return DeleteModal(
                                                                                    title: '댓글이',
                                                                                    text: '등록된 댓글을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                                                    tapFunc: () async {
                                                                                      await CozyLogCommentApiService().deleteComment(
                                                                                        context,
                                                                                        widget.cozyLog.cozyLogId!,
                                                                                        subComment.commentId,
                                                                                      );
                                                                                      setState(() {
                                                                                        widget.requestCommentsUpdate();
                                                                                      });
                                                                                    },
                                                                                  );
                                                                                },
                                                                                barrierDismissible: false,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ]),
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            height: AppUtils
                                                                .scaleSize(
                                                                    context,
                                                                    15),
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
                                                                style:
                                                                    TextStyle(
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
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container(),
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
