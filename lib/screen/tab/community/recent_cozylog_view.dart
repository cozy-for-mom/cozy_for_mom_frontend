import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/cozylog_model.dart';

class CozylogViewWidget extends StatelessWidget {
  final CozyLog cozylog;
  const CozylogViewWidget({super.key, required this.cozylog});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200, // TODO 화면 너비에 맞춘 width로 수정해야함
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cozylog.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: mainTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(cozylog.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: offButtonTextColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 12)),
                    const SizedBox(height: 6),
                    Text(cozylog.date,
                        style: const TextStyle(
                            color: Color(0xffAAAAAA),
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                  ],
                ),
              ),
              (cozylog.imageCount == 0 || cozylog.imageUrl == null)
                  ? Container()
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            image: AssetImage(cozylog.imageUrl!),
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 7,
                          right: 7,
                          child: Container(
                            width: 24,
                            height: 18,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 0, 0, 0.4),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${cozylog.imageCount}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: 144,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Image(
                          image: AssetImage('assets/images/icons/comment.png'),
                          width: 16,
                          height: 15.68),
                      Text('댓글 ${cozylog.commentCount}',
                          style: const TextStyle(
                              color: Color(0xffAAAAAA),
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 67.76,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Image(
                          image:
                              AssetImage('assets/images/icons/scrap_gray.png'),
                          width: 11.76,
                          height: 15.68),
                      Text('스크랩 ${cozylog.scrapCount}',
                          style: const TextStyle(
                              color: Color(0xffAAAAAA),
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: lineTwoColor, height: 1),
        ],
      ),
    );
  }
}
