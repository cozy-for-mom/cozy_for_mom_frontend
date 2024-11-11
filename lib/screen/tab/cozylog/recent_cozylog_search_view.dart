import 'dart:math';

import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CozylogSearchViewWidget extends StatefulWidget {
  final bool isLast;
  final bool isMyCozyLog;
  final CozyLogSearchResult cozylog;

  const CozylogSearchViewWidget({
    super.key,
    this.isLast = false,
    required this.cozylog,
    this.isMyCozyLog = false,
  });
  @override
  State<CozylogSearchViewWidget> createState() =>
      _CozylogSearchViewWidgetState();
}

class _CozylogSearchViewWidgetState extends State<CozylogSearchViewWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingValue = screenWidth > 600 ? 30.w : 20.w;
    return SizedBox(
      width: screenWidth - 2 * paddingValue,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CozyLogDetailScreen(
                    id: widget.cozylog.id,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 24.w),
                SizedBox(
                  width: screenWidth - (40.w + 2 * paddingValue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: widget.cozylog.imageCount < 1
                            ? screenWidth * (2 / 3)
                            : screenWidth / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.cozylog.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: mainTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(16.sp, 26))),
                            SizedBox(height: 6.w),
                            SizedBox(
                              height: 36.w,
                              child: Text(widget.cozylog.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: offButtonTextColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: min(12.sp, 22))),
                            ),
                            SizedBox(height: 6.w),
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy. MM. dd')
                                      .format(widget.cozylog.date),
                                  style: TextStyle(
                                    color: const Color(0xffAAAAAA),
                                    fontWeight: FontWeight.w500,
                                    fontSize: min(12.sp, 22),
                                  ),
                                ),
                                // widget.isMyCozyLog
                                //     ? Row(
                                //         children: [
                                //           Text(
                                //             " · ",
                                //             style: TextStyle(
                                //               color: const Color(0xffAAAAAA),
                                //               fontWeight: FontWeight.w500,
                                //               fontSize: min(12.sp, 22),
                                //             ),
                                //           ),
                                          // widget.cozylog.mode ==  // TODO API 수정 필요(mode 받아오도록), cozylog_model의 CozyLogSearchResult 클래스도 수정하기
                                          //         CozyLogModeType.public
                                          //     ? Text(
                                          //         '공개',
                                          //         style: TextStyle(
                                          //           color:
                                          //               const Color(0xffAAAAAA),
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: min(12.sp, 22),
                                          //         ),
                                          //       )
                                          //     : Text(
                                          //         '비공개',
                                          //         style: TextStyle(
                                          //           color:
                                          //               const Color(0xffAAAAAA),
                                          //           fontWeight: FontWeight.w500,
                                          //           fontSize: min(12.sp, 22),
                                          //         ),
                                          //       )
                                    //     ],
                                    //   )
                                    // : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      (widget.cozylog.imageCount == 0)
                          ? Container()
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.w),
                                  child: Image.network(
                                    widget.cozylog.imageUrl,
                                    width: min(88.w, 168),
                                    height: min(88.w, 168),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 7.h,
                                  right: 7.w,
                                  child: Container(
                                    width: 24.w,
                                    height: 18.w,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 0, 0, 0.4),
                                        borderRadius:
                                            BorderRadius.circular(10.w)),
                                    child: Center(
                                      child: Text(
                                        '${widget.cozylog.imageCount}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: min(12.sp, 22)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 13.w),
                SizedBox(
                  width: 144.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                                image: const AssetImage(
                                    'assets/images/icons/comment.png'),
                                width: min(16.w, 26),
                                height: min(15.68.w, 25.68)),
                            SizedBox(width: 7.w),
                            Text('댓글 ${widget.cozylog.commentCount}',
                                style: TextStyle(
                                    color: const Color(0xffAAAAAA),
                                    fontWeight: FontWeight.w600,
                                    fontSize: min(12.sp, 22))),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage(
                                  'assets/images/icons/scrap_gray.png'),
                              width: min(11.76.w, 21.76),
                              height: min(15.68.w, 25.68),
                            ),
                            SizedBox(width: 7.w),
                            Text(
                              '스크랩 ${widget.cozylog.scrapCount}',
                              style: TextStyle(
                                color: const Color(0xffAAAAAA),
                                fontWeight: FontWeight.w600,
                                fontSize: min(12.sp, 22),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isLast ? SizedBox(height: 24.w) : SizedBox(height: 20.w),
              ],
            ),
          ),
          if (!widget.isLast) const Divider(color: mainLineColor, height: 1),
        ],
      ),
    );
  }
}
