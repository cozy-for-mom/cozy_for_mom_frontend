import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/block_api_service.dart';
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
  final reportedReasons = [
    "비방, 불쾌감을 주는 글이에요.",
    "허위 정보가 있는 글이에요.",
    "광고성 내용이 포함된 글이에요.",
    "선정적, 음란물을 작성해 거부감을 느껴요.",
  ];

  int? selectedCommentIndex;
  int? selectedSubCommentIndex;

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    BlockApiService blockApi = BlockApiService();
    final isSmall = screenHeight < 670;
    final paddingValue = 20.w;
    setIsMyComment();

    DateFormat dateFormat = DateFormat('yyyy. MM. dd HH:mm');

    return Column(
      children: [
        widget.comment.isDeleted || widget.comment.isReported!
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.comment.isDeleted ? "댓글이 삭제되었습니다." : "신고된 댓글입니다.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: min(14.sp, 24),
                  ),
                ))
            : Row(
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
                  SizedBox(
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
                            final baseHeight = widget.isMyCozyLog || isMyComment
                                ? 234.w
                                : 234.w - 60.w;
                            return SizedBox(
                              height: baseHeight,
                              width: screenWidth - 2 * paddingValue,
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.w),
                                    width: screenWidth - 2 * paddingValue,
                                    // 내가 작성한 코지로그에 다른 사람이 작성한 댓글일 경우 1.댓글 신고하기 2.댓글 삭제하기
                                    // 타인이 작성한 코지로그에 다른 사람이 작성한 댓글일 경우 1.댓글 신고하기
                                    // 내가 작성한 댓글일 경우 1.수정하기 2.삭제하기
                                    height: widget.isMyCozyLog || isMyComment
                                        ? 153.w - paddingValue
                                        : 95.w - paddingValue,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.w),
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
                                                          color: mainTextColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              min(16.sp, 26)),
                                                    )),
                                                    onTap: () {
                                                      widget.onCommentUpdate(
                                                          widget.comment);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: Center(
                                                        child: Text(
                                                      '삭제하기',
                                                      style: TextStyle(
                                                          color: mainTextColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              min(16.sp, 26)),
                                                    )),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DeleteModal(
                                                            title: '댓글이',
                                                            text:
                                                                '등록된 댓글을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                            tapFunc: () async {
                                                              await CozyLogCommentApiService()
                                                                  .deleteComment(
                                                                context,
                                                                widget.cozyLog
                                                                    .cozyLogId!,
                                                                widget.comment
                                                                    .commentId,
                                                              );
                                                              setState(() {
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
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Center(
                                                        child: Text(
                                                      '댓글 신고하기',
                                                      style: TextStyle(
                                                          color:
                                                              deleteButtonColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              min(16.sp, 26)),
                                                    )),
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        isScrollControlled:
                                                            true,
                                                        elevation: 0.0,
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      modalSetState) {
                                                            return Wrap(
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                    margin: EdgeInsets.only(
                                                                        bottom: min(
                                                                            15.w,
                                                                            15)),
                                                                    height:
                                                                        20.w,
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .close),
                                                                      iconSize: min(
                                                                          20.w,
                                                                          40),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(); // 팝업 닫기
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: isSmall? screenHeight * 0.7 : screenHeight * 0.6,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(20.w),
                                                                        topRight:
                                                                            Radius.circular(20.w),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 30
                                                                              .w,
                                                                          horizontal:
                                                                              25.w),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "댓글 신고 사유를 알려주세요.",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: min(22.sp, 32),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5.w,
                                                                          ),
                                                                          Text(
                                                                            "신고하는 이유에 해당하는 항목을 선택해주세요.",
                                                                            style:
                                                                                TextStyle(
                                                                              color: const Color(0xff8C909E),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: min(14.sp, 24),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                min(30.w, 40),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                ListView.builder(
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              itemCount: reportedReasons.length,
                                                                              itemBuilder: (context, index) {
                                                                                return Padding(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                    vertical: min(8.w, 12),
                                                                                  ),
                                                                                  child: Container(
                                                                                    height: min(48.w, 88),
                                                                                    decoration: BoxDecoration(
                                                                                      color: const Color(0xffF7F7FA),
                                                                                      borderRadius: BorderRadius.circular(10.w),
                                                                                      border: selectedCommentIndex == index
                                                                                          ? Border.all(
                                                                                              color: primaryColor,
                                                                                              width: 2.w,
                                                                                            )
                                                                                          : null,
                                                                                    ),
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        modalSetState(() {
                                                                                          if (selectedCommentIndex == index) {
                                                                                            selectedCommentIndex = null; // 선택 해제
                                                                                          } else {
                                                                                            selectedCommentIndex = index; // 선택 변경
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      child: Align(
                                                                                        alignment: Alignment.centerLeft,
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: min(20.w, 30)),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Icon(
                                                                                                Icons.check,
                                                                                                color: selectedCommentIndex == index ? primaryColor : const Color(0xffD9D9D9),
                                                                                                size: min(18.w, 28),
                                                                                                weight: 5.w,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 20.w,
                                                                                              ),
                                                                                              Text(
                                                                                                reportedReasons[index],
                                                                                                textAlign: TextAlign.start,
                                                                                                style: TextStyle(
                                                                                                  color: selectedCommentIndex == index ? Colors.black : const Color(0xff858998),
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontSize: min(14.sp, 24),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop(); // 팝업 닫기
                                                                                },
                                                                                child: Container(
                                                                                  width: screenWidth * 0.42,
                                                                                  height: min(48.w, 88),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      borderRadius: BorderRadius.circular(30.w),
                                                                                      border: Border.all(
                                                                                        color: const Color(0xffD9D9D9),
                                                                                        width: 1.w,
                                                                                      )),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      '취소',
                                                                                      style: TextStyle(color: const Color(0xff858998), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  if (selectedCommentIndex != null) {
                                                                                    await blockApi.violateComment(context, widget.comment.commentId, reportedReasons[selectedCommentIndex!]);
                                                                                    if (mounted) {
                                                                                      await CompleteAlertModal.showCompleteDialog(context, '댓글이', '신고');
                                                                                    }
                                                                                    if (mounted) {
                                                                                      Navigator.pop(context, true); // 신고 사유 선택 모달 닫힘
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  width: screenWidth * 0.42,
                                                                                  height: min(48.w, 88),
                                                                                  decoration: BoxDecoration(
                                                                                      color: Colors.transparent,
                                                                                      borderRadius: BorderRadius.circular(30.w),
                                                                                      border: Border.all(
                                                                                        color: selectedCommentIndex == null ? offButtonColor : const Color(0xffFC4141),
                                                                                        width: 1.w,
                                                                                      )),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      '신고하기',
                                                                                      style: TextStyle(color: selectedCommentIndex == null ? offButtonColor : const Color(0xffFC4141), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ]);
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  widget.isMyCozyLog
                                                      ? ListTile(
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
                                                        )
                                                      : Container(),
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
                                      width: screenWidth - 2 * paddingValue,
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
                ],
              ),
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
                              subComment.isDeleted || subComment.isReported!
                                  ? subComment.isDeleted
                                      ? Container()
                                      : Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 15.w),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "신고된 댓글입니다.",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: min(14.sp, 24),
                                                ),
                                              )),
                                        )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 50.w), // 왼쪽 패딩으로 인덴트 조정
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
                                          SizedBox(
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
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0.0,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    final baseHeight = widget
                                                                .isMyCozyLog ||
                                                            subComment
                                                                    .writerId ==
                                                                userId
                                                        ? 234.w
                                                        : 234.w - 60.w;
                                                    return SizedBox(
                                                      height: baseHeight,
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
                                                            height: widget
                                                                        .isMyCozyLog ||
                                                                    subComment
                                                                            .writerId ==
                                                                        userId
                                                                ? 153.w -
                                                                    paddingValue
                                                                : 95.w -
                                                                    paddingValue,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.w),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: subComment
                                                                        .writerId ==
                                                                    userId
                                                                ? Center(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: <Widget>[
                                                                          ListTile(
                                                                            title: Center(
                                                                                child: Text(
                                                                              '수정하기',
                                                                              style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: min(16.sp, 26)),
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
                                                                              style: TextStyle(color: mainTextColor, fontWeight: FontWeight.w600, fontSize: min(16.sp, 26)),
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
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          ListTile(
                                                                            // TODO 중복 코드 -> 컴포넌트로 빼서 사용하기
                                                                            title: Center(
                                                                                child: Text(
                                                                              '댓글 신고하기',
                                                                              style: TextStyle(color: deleteButtonColor, fontWeight: FontWeight.w600, fontSize: min(16.sp, 26)),
                                                                            )),
                                                                            onTap:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              showModalBottomSheet(
                                                                                backgroundColor: Colors.transparent,
                                                                                isScrollControlled: true,
                                                                                elevation: 0.0,
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return StatefulBuilder(builder: (BuildContext context, StateSetter modalSetState) {
                                                                                    return Wrap(children: [
                                                                                      Container(
                                                                                        alignment: AlignmentDirectional.centerEnd,
                                                                                        margin: EdgeInsets.only(bottom: min(15.w, 15)),
                                                                                        height: 20.w,
                                                                                        child: IconButton(
                                                                                          icon: const Icon(Icons.close),
                                                                                          iconSize: min(20.w, 40),
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop(); // 팝업 닫기
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        height: isSmall? screenHeight * 0.7 : screenHeight * 0.6,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(20.w),
                                                                                            topRight: Radius.circular(20.w),
                                                                                          ),
                                                                                        ),
                                                                                        child: Padding(
                                                                                          padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 25.w),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                "댓글 신고 사유를 알려주세요.",
                                                                                                style: TextStyle(
                                                                                                  color: Colors.black,
                                                                                                  fontWeight: FontWeight.w600,
                                                                                                  fontSize: min(22.sp, 32),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 5.w,
                                                                                              ),
                                                                                              Text(
                                                                                                "신고하는 이유에 해당하는 항목을 선택해주세요.",
                                                                                                style: TextStyle(
                                                                                                  color: const Color(0xff8C909E),
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: min(14.sp, 24),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: min(30.w, 40),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: ListView.builder(
                                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                                  itemCount: reportedReasons.length,
                                                                                                  itemBuilder: (context, index) {
                                                                                                    return Padding(
                                                                                                      padding: EdgeInsets.symmetric(
                                                                                                        vertical: min(8.w, 12),
                                                                                                      ),
                                                                                                      child: Container(
                                                                                                        height: min(48.w, 88),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: const Color(0xffF7F7FA),
                                                                                                          borderRadius: BorderRadius.circular(10.w),
                                                                                                          border: selectedSubCommentIndex == index
                                                                                                              ? Border.all(
                                                                                                                  color: primaryColor,
                                                                                                                  width: 2.w,
                                                                                                                )
                                                                                                              : null,
                                                                                                        ),
                                                                                                        child: InkWell(
                                                                                                          onTap: () {
                                                                                                            modalSetState(() {
                                                                                                              if (selectedSubCommentIndex == index) {
                                                                                                                selectedSubCommentIndex = null; // 선택 해제
                                                                                                              } else {
                                                                                                                selectedSubCommentIndex = index; // 선택 변경
                                                                                                              }
                                                                                                            });
                                                                                                          },
                                                                                                          child: Align(
                                                                                                            alignment: Alignment.centerLeft,
                                                                                                            child: Padding(
                                                                                                              padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: min(20.w, 30)),
                                                                                                              child: Row(
                                                                                                                children: [
                                                                                                                  Icon(
                                                                                                                    Icons.check,
                                                                                                                    color: selectedSubCommentIndex == index ? primaryColor : const Color(0xffD9D9D9),
                                                                                                                    size: min(18.w, 28),
                                                                                                                    weight: 5.w,
                                                                                                                  ),
                                                                                                                  SizedBox(
                                                                                                                    width: 20.w,
                                                                                                                  ),
                                                                                                                  Text(
                                                                                                                    reportedReasons[index],
                                                                                                                    textAlign: TextAlign.start,
                                                                                                                    style: TextStyle(
                                                                                                                      color: selectedSubCommentIndex == index ? Colors.black : const Color(0xff858998),
                                                                                                                      fontWeight: FontWeight.w400,
                                                                                                                      fontSize: min(14.sp, 24),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  InkWell(
                                                                                                    onTap: () {
                                                                                                      Navigator.of(context).pop(); // 팝업 닫기
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      width: screenWidth * 0.42,
                                                                                                      height: min(48.w, 88),
                                                                                                      decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(30.w),
                                                                                                          border: Border.all(
                                                                                                            color: const Color(0xffD9D9D9),
                                                                                                            width: 1.w,
                                                                                                          )),
                                                                                                      child: Center(
                                                                                                        child: Text(
                                                                                                          '취소',
                                                                                                          style: TextStyle(color: const Color(0xff858998), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    onTap: () async {
                                                                                                      if (selectedSubCommentIndex != null) {
                                                                                                        await blockApi.violateComment(context, subComment.commentId, reportedReasons[selectedSubCommentIndex!]);
                                                                                                        if (mounted) {
                                                                                                          await CompleteAlertModal.showCompleteDialog(context, '댓글이', '신고');
                                                                                                        }
                                                                                                        if (mounted) {
                                                                                                          Navigator.pop(context, true); // 신고 사유 선택 모달 닫힘
                                                                                                        }
                                                                                                      }
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      width: screenWidth * 0.42,
                                                                                                      height: min(48.w, 88),
                                                                                                      decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(30.w),
                                                                                                          border: Border.all(
                                                                                                            color: selectedSubCommentIndex == null ? offButtonColor : const Color(0xffFC4141),
                                                                                                            width: 1.w,
                                                                                                          )),
                                                                                                      child: Center(
                                                                                                        child: Text(
                                                                                                          '신고하기',
                                                                                                          style: TextStyle(color: selectedSubCommentIndex == null ? offButtonColor : const Color(0xffFC4141), fontSize: min(14.sp, 24), fontWeight: FontWeight.w600),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ]);
                                                                                  });
                                                                                },
                                                                              );
                                                                            },
                                                                          ),
                                                                          widget.isMyCozyLog
                                                                              ? ListTile(
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
                                                                                )
                                                                              : Container(),
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
                                                            child: Container(
                                                              width: screenWidth -
                                                                  2 * paddingValue,
                                                              height:
                                                                  min(56.w, 96),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
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
                                                                      FontWeight
                                                                          .w600,
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
                                        ],
                                      ),
                                    ),
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
