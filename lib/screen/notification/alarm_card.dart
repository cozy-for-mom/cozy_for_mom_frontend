import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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

  final SlidableController _slidableController = SlidableController();
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
      padding: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 5)),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Slidable(
          controller: _slidableController,
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.transparent,
              iconWidget: Container(
                width: AppUtils.scaleSize(context, 120),
                decoration: const BoxDecoration(
                  color: deleteButtonColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
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
                            await notificationViewModel
                                .deleteNotification(widget.notification.id);
                            widget.onDelete(widget.notification.id);
                            setState(() {
                              _slidableController.activeState?.close();
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
                          width: AppUtils.scaleSize(context, 17.5),
                          height: AppUtils.scaleSize(context, 18),
                        ),
                        SizedBox(height: AppUtils.scaleSize(context, 5)),
                        const Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: AppUtils.scaleSize(context, 24),
                horizontal: AppUtils.scaleSize(context, 20)),
            decoration: BoxDecoration(
                color: contentBoxTwoColor,
                borderRadius: BorderRadius.circular(20.0)),
            width: screenWidth - AppUtils.scaleSize(context, 40),
            height: AppUtils.scaleSize(context, 164),
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
                                      style: const TextStyle(
                                          color: afterInputColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                ),
                                SizedBox(width: AppUtils.scaleSize(context, 8)),
                                Container(
                                  height: AppUtils.scaleSize(context, 22),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppUtils.scaleSize(context, 8)),
                                  decoration: BoxDecoration(
                                      color: widget.notification.isActive
                                          ? const Color(0xffFEEEEE)
                                          : offButtonColor,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Wrap(
                                    children: widget.notification.daysOfWeek
                                        .map((day) {
                                          return Text(
                                            weekDayNames[day]!,
                                            style: TextStyle(
                                                color: widget
                                                        .notification.isActive
                                                    ? const Color(0xffFF9797)
                                                    : offButtonTextColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          );
                                        })
                                        .expand((widget) => [
                                              widget,
                                              SizedBox(
                                                  width: AppUtils.scaleSize(
                                                      context, 8))
                                            ])
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
                                    widget.notification.id, value);
                            widget.onActiveChanged();
                          },
                          activeColor: primaryColor,
                        ),
                      ]),
                  const Divider(color: mainLineColor, thickness: 1),
                  const Text('설정한 시간',
                      style: TextStyle(
                          color: offButtonTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12)),
                  SizedBox(
                    width: AppUtils.scaleSize(context, 312),
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
                              fontSize: 14,
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
