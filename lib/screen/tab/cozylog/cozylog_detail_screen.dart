import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/mom/alarm/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/cozylog_edit_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/my_cozylog.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_component.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_api_service.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/service/user/token_manager.dart'
    as TokenManager;

class CozyLogDetailScreen extends StatefulWidget {
  final int id;
  const CozyLogDetailScreen({
    super.key,
    required this.id,
  });

  @override
  State<CozyLogDetailScreen> createState() => _CozyLogDetailScreenState();
}

class _CozyLogDetailScreenState extends State<CozyLogDetailScreen> {
  late Future<CozyLog> futureCozyLog;
  late Future<List<CozyLogComment>> futureComments;
  bool isMyCozyLog = false;
  int? parentCommentIdToReply;
  int? commentIdToUpdate;
  DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');
  String commentInput = '';
  final tokenManager = TokenManager.TokenManager();
  bool isEditMode = false;


  Image submitIcon = const Image(
      image: AssetImage(
    "assets/images/icons/submit_inactive.png",
  ));

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCozyLog = CozyLogApiService().getCozyLog(widget.id);
    futureCozyLog.then((value) =>
      setIsMyCozyLog(value));

    futureComments = CozyLogCommentApiService().getCozyLogComments(widget.id);
    
  }

    void setIsMyCozyLog(CozyLog cozyLog) async {
    final userId = await tokenManager.getUserId();
      if (cozyLog.writer.id == userId) {
        isMyCozyLog = true;
      }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(400, 80),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      '내 코지로그',
                      style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Image(
                        image: AssetImage('assets/images/icons/alert.png'),
                        height: 32,
                        width: 32,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlarmSettingPage(
                              type: CardType.supplement,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: futureCozyLog,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cozyLog = snapshot.data!;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // new
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cozyLog.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                child: cozyLog.writer.imageUrl == null
                                    ? Image.asset(
                                        "assets/images/icons/momProfile.png")
                                    : Image.network(
                                        cozyLog.writer.imageUrl!,
                                      ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cozyLog.writer.nickname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        dateFormat.format(cozyLog.createdAt),
                                        style: const TextStyle(
                                          color: Color(0xffAAAAAA),
                                        ),
                                      ),
                                      isMyCozyLog
                                          ? Text(
                                              "・${cozyLog.mode == CozyLogModeType.public ? "공개" : "비공개"}",
                                              style: const TextStyle(
                                                color: Color(0xffAAAAAA),
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
                              ? IconButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 220,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
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
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                CozylogEditPage(
                                                              id: widget.id,
                                                            ),
                                                          ),
                                                        );
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
                                                      onTap: () {
                                                        CozyLogApiService()
                                                            .deleteCozyLog(
                                                                cozyLog
                                                                    .cozyLogId!);
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const MyCozylog(), // TODO 개선해야함. 뒤로가기후 새로고침되도록.
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: 350,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color:
                                                        const Color(0xffC9DFF9),
                                                  ),
                                                  child: const Center(
                                                      child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                  icon: const Icon(
                                    Icons.more_vert_outlined,
                                    color: Color(0xff858998),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () async {
                                    // 스크랩 상태에 따른 API 호출
                                    if (cozyLog.isScrapped) {
                                      await CozyLogApiService()
                                          .unscrapCozyLog(widget.id);
                                    } else {
                                      await CozyLogApiService()
                                          .scrapCozyLog(widget.id);
                                    }

                                    // 상태 업데이트
                                    setState(() {
                                      futureCozyLog = CozyLogApiService()
                                          .getCozyLog(widget.id);
                                    });
                                  },
                                  icon: cozyLog.isScrapped
                                      ? const Icon(
                                          Icons.bookmark_rounded,
                                          color: Color(0xff858998),
                                        )
                                      : const Icon(
                                          Icons.bookmark_outline_rounded,
                                          color: Color(0xff858998),
                                        ),
                                ), // TODO 아이콘으로 수정 필요
                        ],
                      ),
                      const Divider(
                        color: Color(0xffE1E1E7),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        cozyLog.content,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        height: 550, // TODO 어떻게 동적으로 크기 조정할 수 있지?
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(), // new
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    cozyLog.imageList[index].description,
                                    style: const TextStyle(
                                      color: Color(0xffAAAAAA),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // 댓글 목록
                      const Divider(
                        height: 5,
                      ),
                      FutureBuilder(
                          future: futureComments,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SizedBox(
                                height: 300,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        CozyLogCommentComponent(
                                            cozyLog: cozyLog,
                                            isMyCozyLog: isMyCozyLog,
                                            comment: snapshot.data![index],
                                            subComments: snapshot
                                                    .data![index].subComments ??
                                                [],
                                            onReply: () {
                                              setState(() {
                                                parentCommentIdToReply =
                                                    snapshot
                                                        .data![index].parentId;
                                                textController.text = '';
                                                submitIcon = const Image(
                                                    image: AssetImage(
                                                  "assets/images/icons/submit_inactive.png",
                                                ));
                                              });
                                            },
                                            requestCommentsUpdate: () {
                                              setState(() {
                                                futureComments =
                                                    CozyLogCommentApiService()
                                                        .getCozyLogComments(
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
                                        const Divider(
                                          height: 5,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      // 댓글 입력
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            color: const Color(0xffF7F7FA),
                          ),
                          child: TextField(
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
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: parentCommentIdToReply != null
                                  ? "답글을 남겨주세요."
                                  : "댓글을 남겨주세요.",
                              hintStyle: const TextStyle(
                                color: Color(0xffBCC0C7),
                                fontSize: 14,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  if (commentInput != '') {
                                    if (commentIdToUpdate == null) {
                                      await CozyLogCommentApiService()
                                          .postComment(
                                        widget.id,
                                        parentCommentIdToReply,
                                        commentInput,
                                      );
                                    } else {
                                      await CozyLogCommentApiService()
                                          .updateComment(
                                        widget.id,
                                        commentIdToUpdate!,
                                        parentCommentIdToReply,
                                        commentInput,
                                      );
                                    }
                                    setState(() {
                                      textController.text = '';
                                      futureComments =
                                          CozyLogCommentApiService()
                                              .getCozyLogComments(widget.id);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: submitIcon,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
