import 'dart:math';

import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AlarmSettingCard extends StatefulWidget {
  final NotificationModel notification;
  final Function() onActiveChanged;
  final Function(int) onDelete;

  const AlarmSettingCard(
      {super.key,
      required this.notification,
      required this.onActiveChanged,
      required this.onDelete});

  @override
  State<AlarmSettingCard> createState() => _AlarmSettingCardState();
}

class _AlarmSettingCardState extends State<AlarmSettingCard> {
  late NotificationApiService notificationViewModel;

  // 요일을 숫자로 매핑하는 맵
  final Map<String, int> dayOrder = {
    'mon': 1,
    'tue': 2,
    'wed': 3,
    'thu': 4,
    'fri': 5,
    'sat': 6,
    'sun': 7
  };
  final Map<String, String> weekDayNames = {
    "mon": "월",
    "tue": "화",
    "wed": "수",
    "thu": "목",
    "fri": "금",
    "sat": "토",
    "sun": "일",
    "all": "매일"
  };
  final Map<String, String> timeNames = {
    "one hour ago": "1시간 전",
    "thirty minutes ago": "30분 전",
    "on time": "정시",
  };
  // 오후 시간 포맷팅
  String formatPmTime(String value) {
    // 12:~ 경우에는 12를 빼지 않는다.
    if (int.parse(value.substring(0, 2)) == 12) {
      return '${int.parse(value.substring(0, 2))}${value.substring(2)}';
    } else {
      return '${int.parse(value.substring(0, 2)) - 12}${value.substring(2)}';
    }
  }

  // 오전 시간 포맷팅
  String formatAmTime(String value) {
    // 12:~ 경우에는 12를 더한다.
    if (int.parse(value.substring(0, 2)) == 0) {
      return '${int.parse(value.substring(0, 2)) + 12}${value.substring(2)}';
    } else {
      return '${int.parse(value.substring(0, 2))}${value.substring(2)}';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;
    NotificationApiService notificationViewModel =
        Provider.of<NotificationApiService>(context, listen: false);
    // 월화수목금토일 순으로 정렬
    widget.notification.daysOfWeek
        .sort((a, b) => dayOrder[a]!.compareTo(dayOrder[b]!));
    //  targetTimeAt을 시간 순으로 정렬 (시간 -> 분)
    widget.notification.targetTimeAt.sort((a, b) {
      int hourA = int.parse(a.replaceAll(' ', '').substring(0, 2));
      int minuteA = int.parse(a.replaceAll(' ', '').substring(3));
      int hourB = int.parse(b.replaceAll(' ', '').substring(0, 2));
      int minuteB = int.parse(b.replaceAll(' ', '').substring(3));

      if (hourA == hourB) {
        return minuteA.compareTo(minuteB);
      }
      return hourA.compareTo(hourB);
    });
    return Padding(
      padding: EdgeInsets.only(bottom: 5.w),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        child: Slidable(
          key: ValueKey(widget.notification.id),  // 기존 State가 다음 아이템에 붙어서 슬라이드 상태가 이어지는 현상 방지
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              CustomSlidableAction(
                padding: EdgeInsets.zero,
                foregroundColor: deleteButtonColor,
                autoClose: true,
                flex: 1,
                onPressed: (context) {
                  // 삭제 다이얼로그 띄우기
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext buildContext) {
                      return DeleteModal(
                        text: '등록된 알림을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                        title: '알림이',
                        tapFunc: () async {
                          await notificationViewModel.deleteNotification(
                            context,
                            widget.notification.id,
                          );
                          widget.onDelete(widget.notification.id);
                          setState(() {
                            Slidable.of(buildContext)?.close();
                          });
                        },
                      );
                    },
                  );
                },
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: deleteButtonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.w),
                      bottomRight: Radius.circular(20.w),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext buildContext) {
                          return DeleteModal(
                            text: '등록된 알림을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                            title: '알림이',
                            tapFunc: () async {
                              await notificationViewModel.deleteNotification(
                                context,
                                widget.notification.id,
                              );
                              widget.onDelete(widget.notification.id);
                              setState(() {
                                Slidable.of(buildContext)?.close();
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: const AssetImage(
                              'assets/images/icons/delete.png'),
                          width: min(17.5.w, 27.5),
                          height: min(18.w, 28),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: min(14.sp, 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 20.w),
            decoration: BoxDecoration(
                color: contentBoxTwoColor,
                borderRadius: BorderRadius.circular(20.w)),
            width: screenWidth - 2 * paddingValue,
            height: min(164.w, 328),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: screenWidth * 0.6),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(widget.notification.title,
                                      style: TextStyle(
                                          color: afterInputColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: min(18.sp, 28)),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.w),
                                  decoration: BoxDecoration(
                                      color: widget.notification.isActive
                                          ? const Color(0xffFEEEEE)
                                          : offButtonColor,
                                      borderRadius: BorderRadius.circular(8.w)),
                                  child: Wrap(
                                    children: widget.notification.daysOfWeek
                                        .map((day) {
                                          return Text(
                                            weekDayNames[day]!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: widget
                                                        .notification.isActive
                                                    ? const Color(0xffFF9797)
                                                    : offButtonTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: min(12.sp, 22)),
                                          );
                                        })
                                        .expand((widget) =>
                                            [widget, SizedBox(width: 8.w)])
                                        .toList()
                                      ..removeLast(),
                                  ),
                                ),
                              ]),
                        ),
                        CupertinoSwitch(
                          value: widget.notification.isActive,
                          onChanged: (value) async {
                            await notificationViewModel
                                .modifyNotificationActive(
                                    context, widget.notification.id, value);
                            widget.onActiveChanged();
                          },
                          activeTrackColor: primaryColor,
                        ),
                      ]),
                  const Divider(color: mainLineColor, thickness: 1),
                  Text('설정한 시간',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: min(12.sp, 22))),
                  SizedBox(
                    width: 312.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            '${widget.notification.targetTimeAt.map((time) => int.parse(time.substring(0, 2)) > 11 ? '오후 ${formatPmTime(time)}' : '오전 ${formatAmTime(time)}').join('\t\t\t\t')}\t\t\t\t${timeNames[widget.notification.notifyAt] == "정시" ? '' : '${timeNames[widget.notification.notifyAt]} 알림'}',
                            style: TextStyle(
                              color: widget.notification.isActive
                                  ? primaryColor
                                  : offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(14.sp, 24),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
