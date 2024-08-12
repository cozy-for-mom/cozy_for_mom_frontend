import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/service/cozylog/cozylog_comment_api_service.dart';
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
    DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');
    bool isMyComment = comment.writerId == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 15.0,
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
                          height: 50,
                          child: comment.writerImageUrl == null
                              ? Image.asset(
                                  "assets/images/icons/momProfile.png")
                              : Image.network(
                                  comment.writerImageUrl!,
                                ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.writerNickname,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                comment.content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    dateFormat.format(comment.createdAt),
                                    style: const TextStyle(
                                      color: Color(0xffAAAAAA),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  InkWell(
                                    onTap: onReply,
                                    child: const Text(
                                      "답글쓰기",
                                      style: TextStyle(
                                        color: Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
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
                                                            fontSize: 16.0);
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
                                                            fontSize: 16.0);
                                                        requestCommentsUpdate();
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
              ? const SizedBox(
                  height: 20,
                )
              : const SizedBox(),
          subComments.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 50.0), // 왼쪽 패딩으로 인덴트 조정
                  child: Column(
                    children: subComments.map((subComment) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
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
                                          height: 50,
                                          child: comment.writerImageUrl == null
                                              ? Image.asset(
                                                  "assets/images/icons/momProfile.png")
                                              : Image.network(
                                                  comment.writerImageUrl!,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              subComment.writerNickname,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              subComment.content,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  dateFormat.format(
                                                      comment.createdAt),
                                                  style: const TextStyle(
                                                    color: Color(0xffAAAAAA),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
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
                                                    height: 220,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: 350,
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
                                                                                fontSize: 16.0);

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
                                                                                fontSize: 16.0);
                                                                            requestCommentsUpdate();
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
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: 350,
                                                            height: 56,
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
