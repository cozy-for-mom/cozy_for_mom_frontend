import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    setIsMyComment();

    DateFormat dateFormat = DateFormat('yyyy. MM. dd HH:mm');

    return Column(
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
                        child: widget.comment.writerImageUrl == null
                            ? Image.asset("assets/images/icons/momProfile.png",
                                width: min(50.w, 100), height: min(50.w, 100))
                            : ClipOval(
                                child: Image.network(
                                    widget.comment.writerImageUrl!,
                                    fit: BoxFit.cover,
                                    width: min(50.w, 100),
                                    height: min(50.w, 100)),
                              ),
                      ),
                      SizedBox(
                        width: 17.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 240.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.comment.writerNickname,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(14.sp, 24),
                                  ),
                                ),
                                widget.cozyLog.writer.nickname ==
                                        widget.comment.writerNickname
                                    ? Container(
                                        width: 46.w,
                                        height: 19.w,
                                        margin: EdgeInsets.only(left: 7.w),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20.w),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '작성자',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: min(10.sp, 20),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          SizedBox(
                            width: 270.w - paddingValue,
                            child: Text(
                              widget.comment.content,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: min(14.sp, 24),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          Row(
                            children: [
                              Text(
                                dateFormat.format(widget.comment.createdAt),
                                style: TextStyle(
                                  color: const Color(0xffAAAAAA),
                                  fontWeight: FontWeight.w500,
                                  fontSize: min(12.sp, 22),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              InkWell(
                                onTap: widget.onReply,
                                child: Text(
                                  "답글쓰기",
                                  style: TextStyle(
                                    color: const Color(0xffAAAAAA),
                                    fontWeight: FontWeight.w500,
                                    fontSize: min(12.sp, 22),
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
                          width: 15.w,
                          child: IconButton(
                            icon: Image(
                              image: const AssetImage(
                                  'assets/images/icons/more_vert_outlined.png'),
                              color: const Color(0xff858998),
                              width: min(3.w, 6),
                              height: min(17.w, 34),
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showModalBottomSheet<void>(
                                // TODO 모달 너비 screenWidth - 2*paddingValue로 수정
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: isMyComment
                                        ? isTablet
                                            ? 234.w - paddingValue
                                            : 234.w
                                        : (234 - 60).w - paddingValue,
                                    width: screenWidth - 2 * paddingValue,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.w),
                                          width: screenWidth - 2 * paddingValue,
                                          height: isMyComment
                                              ? 148.w - paddingValue
                                              : 88.w - paddingValue,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.w),
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
                                                                fontSize: min(
                                                                    16.sp, 26)),
                                                          )),
                                                          onTap: () {
                                                            widget.onCommentUpdate(
                                                                widget.comment);
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
                                                                fontSize: min(
                                                                    16.sp, 26)),
                                                          )),
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DeleteModal(
                                                                  title: '댓글이',
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
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
                                                                fontSize: min(
                                                                    16.sp, 26)),
                                                          )),
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return DeleteModal(
                                                                  title: '댓글이',
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
                                          height: 15.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width:
                                                screenWidth - 2 * paddingValue,
                                            height: min(56.w, 96),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.w),
                                              color: induceButtonColor,
                                            ),
                                            child: Center(
                                                child: Text(
                                              "취소",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: min(16.sp, 26),
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
            : Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "댓글이 삭제되었습니다.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: min(14.sp, 24),
                  ),
                )),
        widget.subComments.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 15.w,
                  ),
                  Divider(
                    color: const Color(0xffE1E1E7),
                    height: 1.w,
                  ),
                ],
              )
            : SizedBox(
                height: 15.w,
              ),
        widget.subComments.isNotEmpty
            ? Column(
                children: widget.subComments
                    .asMap()
                    .map((index, subComment) {
                      return MapEntry(
                          index,
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              !subComment.isDeleted
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: isTablet
                                              ? 40.w
                                              : 50.w), // 왼쪽 패딩으로 인덴트 조정
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                height: 50.w,
                                                child: subComment
                                                            .writerImageUrl ==
                                                        null
                                                    ? Image.asset(
                                                        "assets/images/icons/momProfile.png",
                                                        fit: BoxFit.cover,
                                                        width: min(50.w, 100),
                                                        height: min(50.w, 100))
                                                    : ClipOval(
                                                        child: Image.network(
                                                            subComment
                                                                .writerImageUrl!,
                                                            fit: BoxFit.cover,
                                                            width:
                                                                min(50.w, 100),
                                                            height:
                                                                min(50.w, 100)),
                                                      ),
                                              ),
                                              SizedBox(
                                                width: 17.w,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        subComment
                                                            .writerNickname,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              min(14.sp, 24),
                                                        ),
                                                      ),
                                                      widget.cozyLog.writer
                                                                  .nickname ==
                                                              subComment
                                                                  .writerNickname
                                                          ? Container(
                                                              width: 46.w,
                                                              height: 19.w,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left:
                                                                          7.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.w),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  '작성자',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize: min(
                                                                        10.sp,
                                                                        20),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.w,
                                                  ),
                                                  SizedBox(
                                                    width: 220.w - paddingValue,
                                                    child: Text(
                                                      subComment.content,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              min(14.sp, 24)),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.w),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        dateFormat.format(widget
                                                            .comment.createdAt),
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xffAAAAAA),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                min(12.sp, 22)),
                                                      ),
                                                      SizedBox(width: 7.w),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15.w),
                                                ],
                                              ),
                                            ],
                                          ),
                                          widget.isMyCozyLog ||
                                                  subComment.writerId == userId
                                              ? SizedBox(
                                                  width: 15.w,
                                                  child: IconButton(
                                                    icon: Image(
                                                      image: const AssetImage(
                                                          'assets/images/icons/more_vert_outlined.png'),
                                                      color: const Color(
                                                          0xff858998),
                                                      width: min(3.w, 6),
                                                      height: min(17.w, 34),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                          void>(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0.0,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: subComment.writerId ==
                                                                    userId
                                                                ? 234.w -
                                                                    paddingValue
                                                                : (234 - 60).w -
                                                                    paddingValue,
                                                            width: screenWidth -
                                                                2 * paddingValue,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              8.w),
                                                                  width: screenWidth -
                                                                      2 * paddingValue,
                                                                  height: subComment
                                                                              .writerId ==
                                                                          userId
                                                                      ? 148.w -
                                                                          paddingValue
                                                                      : 88.w -
                                                                          paddingValue,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.w),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: subComment
                                                                              .writerId ==
                                                                          userId
                                                                      ? Center(
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  title: Center(
                                                                                      child: Text(
                                                                                    '수정하기',
                                                                                    style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: min(16.sp, 26)),
                                                                                  )),
                                                                                  onTap: () {
                                                                                    widget.onCommentUpdate(subComment);
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                                ListTile(
                                                                                  title: Center(
                                                                                      child: Text(
                                                                                    '삭제하기',
                                                                                    style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: min(16.sp, 26)),
                                                                                  )),
                                                                                  onTap: () async {
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
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                ListTile(
                                                                                  title: Center(
                                                                                      child: Text(
                                                                                    '댓글 삭제하기',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: min(16.sp, 26),
                                                                                    ),
                                                                                  )),
                                                                                  onTap: () async {
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
                                                                  height: 15.w,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: screenWidth -
                                                                        2 * paddingValue,
                                                                    height: min(
                                                                        56.w,
                                                                        96),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.w),
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
                                                                            FontWeight.w600,
                                                                        fontSize: min(
                                                                            16.sp,
                                                                            26),
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
                                      ),
                                    )
                                  : Container(),
                              if (index != widget.subComments.length - 1)
                                Divider(
                                  color: const Color(0xffE1E1E7),
                                  height: 1.w,
                                ),
                            ],
                          ));
                    })
                    .values
                    .toList(),
              )
            : Container(),
        Divider(
          color: const Color(0xffE1E1E7),
          height: 1.w,
        ),
      ],
    );
  }
}
