import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CozyLogCommentComponent extends StatelessWidget {
  const CozyLogCommentComponent({
    super.key,
    required this.comment,
    required this.subComments,
    required this.onReply,
  });

  final CozyLogComment comment;
  final List<CozyLogComment> subComments;
  final Function() onReply;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 15.0,
      ),
      child: Column(
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
                    ? Image.asset("assets/images/icons/momProfile.png")
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
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      comment.content,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subComment.writerNickname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    subComment.content,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        dateFormat.format(subComment.createdAt),
                                        style: const TextStyle(
                                          color: Color(0xffAAAAAA),
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
