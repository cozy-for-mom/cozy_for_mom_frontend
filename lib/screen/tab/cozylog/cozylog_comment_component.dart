import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CozyLogCommentComponent extends StatelessWidget {
  const CozyLogCommentComponent({
    super.key,
    required this.comment,
    required this.subComments,
  });

  final CozyLogComment comment;
  final List<CozyLogComment> subComments;

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
                        const Text(
                          "답글쓰기",
                          style: TextStyle(
                            color: Color(0xffAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          subComments.isNotEmpty
              ? SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
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
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: subComments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subComments[index].writerNickname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  subComments[index].content,
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
                                      dateFormat
                                          .format(subComments[index].createdAt),
                                      style: const TextStyle(
                                        color: Color(0xffAAAAAA),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    // const Text(
                                    //   "답글쓰기",
                                    //   style: TextStyle(
                                    //     color: Color(0xffAAAAAA),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
