import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_edit_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_component.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

// 목록 --> 상세 페이지 --replacement--> 수정페이지 --replacement--> 상세페이지
class CozyLogDetailScreen extends StatefulWidget {
  final int id;
  const CozyLogDetailScreen({super.key, required this.id});

  @override
  State<CozyLogDetailScreen> createState() => _CozyLogDetailScreenState();
}

class _CozyLogDetailScreenState extends State<CozyLogDetailScreen> {
  late Future<CozyLog?> futureCozyLog;
  late Future<List<CozyLogComment>?> futureComments;
  bool isMyCozyLog = false;
  int? parentCommentIdToReply;
  int? commentIdToUpdate;
  DateFormat dateFormat = DateFormat('yyyy. MM. dd HH:mm');
  String commentInput = '';
  final tokenManager = TokenManager.TokenManager();
  bool isEditMode = false;

  Image submitIcon = const Image(
      image: AssetImage(
    "assets/images/icons/submit_inactive.png",
  ));

  TextEditingController textController = TextEditingController();

  void reloadCozyLog() {
    futureCozyLog = CozyLogApiService().getCozyLog(context, widget.id);
  }

  @override
  void initState() {
    super.initState();
    futureCozyLog = CozyLogApiService().getCozyLog(context, widget.id);
    futureCozyLog.then((value) {
      if (value != null) {
        setIsMyCozyLog(value);
      }
    });

    futureComments =
        CozyLogCommentApiService().getCozyLogComments(context, widget.id);
  }

  void setIsMyCozyLog(CozyLog cozyLog) async {
    final userId = await tokenManager.getUserId();
    bool newIsMyCozyLog = cozyLog.writer.id == userId;
    if (newIsMyCozyLog != isMyCozyLog) {
      setState(() {
        isMyCozyLog = newIsMyCozyLog;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: futureCozyLog,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cozyLog = snapshot.data!;
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size(AppUtils.scaleSize(context, 400),
                  AppUtils.scaleSize(context, 57.4)),
              child: Padding(
                padding: EdgeInsets.only(
                    top: AppUtils.scaleSize(context, 8),
                    bottom: AppUtils.scaleSize(context, 8),
                    right: AppUtils.scaleSize(context, 8)),
                child: Column(
                  children: [
                    SizedBox(
                      height: AppUtils.scaleSize(context, 50),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Image(
                            image: const AssetImage(
                                'assets/images/icons/back_ios.png'),
                            width: AppUtils.scaleSize(context, 34),
                            height: AppUtils.scaleSize(context, 34),
                            color: mainTextColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        const Spacer(),
                        Text(
                          isMyCozyLog ? '내 코지로그' : '코지로그',
                          style: TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: AppUtils.scaleSize(context, 20),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: AppUtils.scaleSize(context, 32),
                          height: AppUtils.scaleSize(context, 32),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppUtils.scaleSize(context, 20),
                          vertical: AppUtils.scaleSize(context, 8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cozyLog.title,
                            style: TextStyle(
                                fontSize: AppUtils.scaleSize(context, 20),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 17),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  cozyLog.writer.imageUrl == null
                                      ? Image.asset(
                                          "assets/images/icons/momProfile.png",
                                          width:
                                              AppUtils.scaleSize(context, 50),
                                          height:
                                              AppUtils.scaleSize(context, 50),
                                        )
                                      : ClipOval(
                                          child: Image.network(
                                            cozyLog.writer.imageUrl!,
                                            fit: BoxFit.cover,
                                            width:
                                                AppUtils.scaleSize(context, 50),
                                            height:
                                                AppUtils.scaleSize(context, 50),
                                          ),
                                        ),
                                  SizedBox(
                                    width: AppUtils.scaleSize(context, 15),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cozyLog.writer.nickname,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              AppUtils.scaleSize(context, 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppUtils.scaleSize(context, 5),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            dateFormat
                                                .format(cozyLog.createdAt),
                                            style: TextStyle(
                                              color: const Color(0xffAAAAAA),
                                              fontWeight: FontWeight.w500,
                                              fontSize: AppUtils.scaleSize(
                                                  context, 14),
                                            ),
                                          ),
                                          isMyCozyLog
                                              ? Text(
                                                  "・${cozyLog.mode == CozyLogModeType.public ? "공개" : "비공개"}",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xffAAAAAA),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        AppUtils.scaleSize(
                                                            context, 14),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              isMyCozyLog
                                  ? SizedBox(
                                      width: AppUtils.scaleSize(context, 15),
                                      height: AppUtils.scaleSize(context, 32),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: AppUtils.scaleSize(
                                                    context, 220),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: AppUtils
                                                                  .scaleSize(
                                                                      context,
                                                                      8)),
                                                      width: screenWidth -
                                                          AppUtils.scaleSize(
                                                              context, 40),
                                                      height:
                                                          AppUtils.scaleSize(
                                                              context, 128),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              ListTile(
                                                                title: Center(
                                                                    child: Text(
                                                                  '수정하기',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainTextColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            16),
                                                                  ),
                                                                )),
                                                                onTap:
                                                                    () async {
                                                                  await Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CozylogEditPage(
                                                                        id: widget
                                                                            .id,
                                                                      ),
                                                                    ),
                                                                  ).then(
                                                                      (value) {
                                                                    if (value ==
                                                                        true) {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              ListTile(
                                                                title: Center(
                                                                    child: Text(
                                                                  '글 삭제하기',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        mainTextColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: AppUtils
                                                                        .scaleSize(
                                                                            context,
                                                                            16),
                                                                  ),
                                                                )),
                                                                onTap:
                                                                    () async {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return DeleteModal(
                                                                        title:
                                                                            '코지로그가',
                                                                        text:
                                                                            '삭제된 글은 다시 복구할 수 없습니다.\n삭제하시겠습니까?',
                                                                        tapFunc:
                                                                            () async {
                                                                          await CozyLogApiService().deleteCozyLog(
                                                                              context,
                                                                              cozyLog.cozyLogId!);
                                                                          if (mounted) {
                                                                            Navigator.pop(context,
                                                                                true);
                                                                            Navigator.pop(context,
                                                                                true);
                                                                          }
                                                                          setState(
                                                                              () {});
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
                                                          AppUtils.scaleSize(
                                                              context, 15),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: screenWidth -
                                                            AppUtils.scaleSize(
                                                                context, 40),
                                                        height:
                                                            AppUtils.scaleSize(
                                                                context, 56),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color:
                                                              induceButtonColor,
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          "취소",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                        icon: Image(
                                          image: const AssetImage(
                                              'assets/images/icons/more_vert_outlined.png'),
                                          color: const Color(0xff858998),
                                          width: AppUtils.scaleSize(context, 3),
                                          height:
                                              AppUtils.scaleSize(context, 17),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      width: AppUtils.scaleSize(context, 25),
                                      height: AppUtils.scaleSize(context, 32),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {
                                          // 스크랩 상태에 따른 API 호출
                                          if (cozyLog.isScrapped) {
                                            await CozyLogApiService()
                                                .unscrapCozyLog(
                                                    context, widget.id);
                                          } else {
                                            await CozyLogApiService()
                                                .scrapCozyLog(
                                                    context, widget.id);
                                          }

                                          // 상태 업데이트
                                          setState(() {
                                            futureCozyLog = CozyLogApiService()
                                                .getCozyLog(context, widget.id);
                                          });
                                        },
                                        icon: cozyLog.isScrapped
                                            ? Image(
                                                image: const AssetImage(
                                                    'assets/images/icons/scrap_fill.png'),
                                                width: AppUtils.scaleSize(
                                                    context, 12.75),
                                                height: AppUtils.scaleSize(
                                                    context, 17),
                                              )
                                            : Image(
                                                image: const AssetImage(
                                                    'assets/images/icons/unscrap.png'),
                                                width: AppUtils.scaleSize(
                                                    context, 12.75),
                                                height: AppUtils.scaleSize(
                                                    context, 17),
                                              ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(height: AppUtils.scaleSize(context, 10)),
                          const Divider(
                            color: Color(0xffE1E1E7),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 20),
                          ),
                          Text(
                            cozyLog.content,
                            style: TextStyle(
                                color: mainTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scaleSize(context, 14)),
                          ),
                          SizedBox(
                            height: AppUtils.scaleSize(context, 22),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cozyLog.imageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                child: Column(
                                  children: [
                                    Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Image.network(
                                        cozyLog.imageList[index].imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppUtils.scaleSize(context, 10),
                                    ),
                                    Text(
                                      cozyLog.imageList[index].description,
                                      style: TextStyle(
                                        color: const Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppUtils.scaleSize(context, 12),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: AppUtils.scaleSize(context, 12),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: AppUtils.scaleSize(context, 144),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          'assets/images/icons/scrap_gray.png'),
                                      width: AppUtils.scaleSize(context, 11.76),
                                      height:
                                          AppUtils.scaleSize(context, 15.68),
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                        width: AppUtils.scaleSize(context, 8)),
                                    Text(
                                      '스크랩 ${cozyLog.scrapCount}',
                                      style: TextStyle(
                                        color: const Color(0xff8C909E),
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            AppUtils.scaleSize(context, 12),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image(
                                        image: const AssetImage(
                                            'assets/images/icons/comment.png'),
                                        width: AppUtils.scaleSize(context, 16),
                                        height:
                                            AppUtils.scaleSize(context, 15.68),
                                        color: Colors.black),
                                    SizedBox(
                                        width: AppUtils.scaleSize(context, 8)),
                                    Text('댓글 ${cozyLog.commentCount}',
                                        style: TextStyle(
                                            color: const Color(0xff8C909E),
                                            fontWeight: FontWeight.w600,
                                            fontSize: AppUtils.scaleSize(
                                                context, 12))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppUtils.scaleSize(context, 30)),
                          // 댓글 목록
                          Divider(
                            height: AppUtils.scaleSize(context, 30),
                            color: mainLineColor,
                          ),
                          FutureBuilder(
                              future: futureComments,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        if ((!snapshot
                                                .data![index].isDeleted) ||
                                            (snapshot.data![index].isDeleted &&
                                                snapshot.data![index]
                                                    .subComments!.isNotEmpty)) {
                                          return Column(
                                            children: [
                                              CozyLogCommentComponent(
                                                  cozyLog: cozyLog,
                                                  isMyCozyLog: isMyCozyLog,
                                                  comment:
                                                      snapshot.data![index],
                                                  subComments: snapshot
                                                          .data![index]
                                                          .subComments ??
                                                      [],
                                                  onReply: () {
                                                    setState(() {
                                                      parentCommentIdToReply =
                                                          snapshot.data![index]
                                                              .parentId;
                                                      textController.text = '';
                                                      submitIcon = const Image(
                                                          image: AssetImage(
                                                        "assets/images/icons/submit_inactive.png",
                                                      ));
                                                    });
                                                  },
                                                  requestCommentsUpdate: () {
                                                    setState(() {
                                                      futureCozyLog =
                                                          CozyLogApiService()
                                                              .getCozyLog(
                                                                  context,
                                                                  widget.id);
                                                      futureComments =
                                                          CozyLogCommentApiService()
                                                              .getCozyLogComments(
                                                                  context,
                                                                  widget.id);
                                                    });
                                                  },
                                                  onCommentUpdate:
                                                      (CozyLogComment comment) {
                                                    setState(() {
                                                      commentIdToUpdate =
                                                          comment.commentId;
                                                      textController.text =
                                                          comment.content;
                                                      submitIcon = const Image(
                                                          image: AssetImage(
                                                        "assets/images/icons/submit_active.png",
                                                      ));
                                                    });
                                                  }),
                                              SizedBox(
                                                  height: AppUtils.scaleSize(
                                                      context, 15)),
                                            ],
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: AppUtils.scaleSize(context, 25),
                      right: AppUtils.scaleSize(context, 25),
                      bottom: AppUtils.scaleSize(context, 25),
                      top: AppUtils.scaleSize(context, 15)),
                  decoration: const BoxDecoration(
                    color: Colors.white, // 배경색 설정
                  ),
                  child: Container(
                    width: screenWidth - AppUtils.scaleSize(context, 40),
                    height: AppUtils.scaleSize(context, 36),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      color: const Color(0xffF7F7FA),
                    ),
                    padding: EdgeInsets.only(
                        left: AppUtils.scaleSize(context, 20),
                        right: AppUtils.scaleSize(context, 6)),
                    child: TextField(
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: AppUtils.scaleSize(context, 14),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      controller: textController,
                      onChanged: (text) {
                        if (text != '') {
                          setState(() {
                            commentInput = text;
                            submitIcon = const Image(
                                image: AssetImage(
                              "assets/images/icons/submit_active.png",
                            ));
                          });
                        } else {
                          setState(() {
                            commentInput = '';
                            submitIcon = const Image(
                                image: AssetImage(
                              "assets/images/icons/submit_inactive.png",
                            ));
                          });
                        }
                      },
                      cursorHeight: 14.5,
                      cursorWidth: 1,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            bottom: (AppUtils.scaleSize(context, 36) -
                                    AppUtils.scaleSize(context, 14) * 1.2) /
                                2 // 폰트 크기와 라인 높이 고려),
                            ),
                        hintText: parentCommentIdToReply != null
                            ? "답글을 남겨주세요."
                            : "댓글을 남겨주세요.",
                        hintStyle: TextStyle(
                          color: const Color(0xffBCC0C7),
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scaleSize(context, 14),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            if (commentInput != '') {
                              if (commentIdToUpdate == null) {
                                await CozyLogCommentApiService().postComment(
                                  context,
                                  widget.id,
                                  parentCommentIdToReply,
                                  commentInput,
                                );
                                reloadCozyLog();
                              } else {
                                await CozyLogCommentApiService().updateComment(
                                  context,
                                  widget.id,
                                  commentIdToUpdate!,
                                  parentCommentIdToReply,
                                  commentInput,
                                );
                              }
                              if (mounted) {
                                await CompleteAlertModal.showCompleteDialog(
                                    context, '댓글이', '등록');
                              }
                              setState(() {
                                textController.text = '';
                                futureComments = CozyLogCommentApiService()
                                    .getCozyLogComments(context, widget.id);
                                parentCommentIdToReply = null;
                              });
                            }
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.all(AppUtils.scaleSize(context, 8)),
                            child: submitIcon,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            backgroundColor: primaryColor,
            color: Colors.white,
          ));
        }
      },
    );
  }
}
