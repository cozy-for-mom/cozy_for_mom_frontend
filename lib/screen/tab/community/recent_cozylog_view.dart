import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/cozylog/cozylog_model.dart';
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
      width: screenWidth - 40,
      child: Column(
        children: [
          Row(
            children: [
              widget.isEditMode
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20),
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
                          width: 20,
                          height: 20,
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
                  children: [
                    const SizedBox(height: 24),
                    SizedBox(
                      width: widget.isEditMode
                          ? screenWidth - 84 - 40
                          : screenWidth - 84,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: widget.cozylog.imageCount < 1
                                ? widget.isEditMode
                                    ? 309 - 40
                                    : 309
                                : widget.isEditMode
                                    ? 200 - 40
                                    : 200, // TODO 화면 너비에 맞춘 width로 수정해야함
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.cozylog.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: mainTextColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16)),
                                const SizedBox(height: 6),
                                Text(widget.cozylog.summary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: offButtonTextColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12)),
                                const SizedBox(height: 6),
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
                                                      '비공개',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffAAAAAA),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  : const Text(
                                                      '공개',
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
                                    image: AssetImage(
                                        'assets/images/icons/comment.png'),
                                    width: 16,
                                    height: 15.68),
                                Text('댓글 ${widget.cozylog.commentCount}',
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
                              children: [
                                const Image(
                                  image: AssetImage(
                                      'assets/images/icons/scrap_gray.png'),
                                  width: 11.76,
                                  height: 15.68,
                                ),
                                const SizedBox(width: 7),
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
                    const SizedBox(height: 24),
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
