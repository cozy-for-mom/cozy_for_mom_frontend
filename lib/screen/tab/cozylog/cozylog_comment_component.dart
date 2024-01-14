import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CozyLogCommentComponent extends StatelessWidget {
  const CozyLogCommentComponent({
    super.key,
    required this.comment,
  });

  final CozyLogComment comment;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy. MM. dd hh:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 15.0,
      ),
      child: Row(
        children: [
          SizedBox(
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
          Column(
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
          )
        ],
      ),
    );
  }
}
