import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/community/list_modify_state.dart';
import 'package:intl/intl.dart';

class CozylogViewWidget extends StatefulWidget {
  final bool isEditMode;
  final bool isMyCozyLog;
  final CozyLogForList cozylog;
  final ListModifyState? listModifyState;
  final ValueChanged<bool>? onSelectedChanged;
  const CozylogViewWidget(
      {super.key,
      this.isEditMode = false,
      required this.cozylog,
      this.isMyCozyLog = false,
      this.listModifyState,
      this.onSelectedChanged});
  @override
  State<CozylogViewWidget> createState() => _CozylogViewWidgetState();
}

class _CozylogViewWidgetState extends State<CozylogViewWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth - AppUtils.scaleSize(context, 40),
      child: Column(
        children: [
          Row(
            children: [
              widget.isEditMode
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: AppUtils.scaleSize(context, 20)),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = !isSelected;
                            widget.onSelectedChanged?.call(!(widget
                                    .listModifyState
                                    ?.isSelected(widget.cozylog.cozyLogId) ??
                                false));
                          });
                        },
                        child: Image(
                          image: widget.listModifyState
                                      ?.isSelected(widget.cozylog.cozyLogId) ??
                                  false
                              //isSelected
                              ? const AssetImage(
                                  'assets/images/icons/select_on.png')
                              : const AssetImage(
                                  'assets/images/icons/select_off.png'),
                          width: AppUtils.scaleSize(context, 20),
                          height: AppUtils.scaleSize(context, 20),
                        ),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CozyLogDetailScreen(
                        id: widget.cozylog.cozyLogId,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: AppUtils.scaleSize(context, 24)),
                    SizedBox(
                      width: widget.isEditMode
                          ? screenWidth - AppUtils.scaleSize(context, 124)
                          : screenWidth - AppUtils.scaleSize(context, 84),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: widget.cozylog.imageCount < 1
                                ? widget.isEditMode
                                    ? screenWidth * (3 / 4) -
                                        AppUtils.scaleSize(context, 40)
                                    : screenWidth * (3 / 4)
                                : widget.isEditMode
                                    ? screenWidth / 2 -
                                        AppUtils.scaleSize(context, 40)
                                    : screenWidth / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.cozylog.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 6)),
                                SizedBox(
                                  height: AppUtils.scaleSize(context, 36),
                                  child: Text(widget.cozylog.summary,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: offButtonTextColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12)),
                                ),
                                SizedBox(
                                    height: AppUtils.scaleSize(context, 6)),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('yyyy. MM. dd')
                                          .format(widget.cozylog.date),
                                      style: const TextStyle(
                                        color: Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    widget.isMyCozyLog
                                        ? Row(
                                            children: [
                                              const Text(
                                                " · ",
                                                style: TextStyle(
                                                  color: Color(0xffAAAAAA),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              widget.cozylog.mode ==
                                                      CozyLogModeType.public
                                                  ? const Text(
                                                      '공개',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffAAAAAA),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  : const Text(
                                                      '비공개',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffAAAAAA),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                            ],
                                          )
                                        : Container(),
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
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        widget.cozylog.imageUrl,
                                        width: AppUtils.scaleSize(context, 88),
                                        height: AppUtils.scaleSize(context, 88),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: AppUtils.scaleSize(context, 7),
                                      right: AppUtils.scaleSize(context, 7),
                                      child: Container(
                                        width: AppUtils.scaleSize(context, 24),
                                        height: AppUtils.scaleSize(context, 18),
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.4),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          '${widget.cozylog.imageCount}',
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
                    ),
                    SizedBox(height: AppUtils.scaleSize(context, 13)),
                    SizedBox(
                      width: AppUtils.scaleSize(context, 144),
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
                                    width: AppUtils.scaleSize(context, 16),
                                    height: AppUtils.scaleSize(context, 15.68)),
                                SizedBox(width: AppUtils.scaleSize(context, 7)),
                                Text('댓글 ${widget.cozylog.commentCount}',
                                    style: const TextStyle(
                                        color: Color(0xffAAAAAA),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Image(
                                  image: const AssetImage(
                                      'assets/images/icons/scrap_gray.png'),
                                  width: AppUtils.scaleSize(context, 11.76),
                                  height: AppUtils.scaleSize(context, 15.68),
                                ),
                                SizedBox(width: AppUtils.scaleSize(context, 7)),
                                Text(
                                  '스크랩 ${widget.cozylog.scrapCount}',
                                  style: const TextStyle(
                                    color: Color(0xffAAAAAA),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppUtils.scaleSize(context, 20)),
                    const Divider(color: lineTwoColor, height: 1),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: mainLineColor, height: 1),
        ],
      ),
    );
  }
}
