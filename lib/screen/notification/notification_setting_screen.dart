import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/notification/notification_setting_card_widget.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationSettingScreen extends StatefulWidget {
  final CardType type;
  final NotificationModel? notification;
  final void Function(int)? onRegister;
  final void Function(int)? onModify;
  const NotificationSettingScreen(
      {super.key,
      required this.type,
      this.notification,
      this.onRegister,
      this.onModify});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  var selectedOneHourAgo = false;
  var selectedThirtyMinutesAgo = false;
  var selectedOnTime = false;

  final selectedTextColor = Colors.white;
  final unselectedTextColor = const Color(0xff858998);
  final selectedBackgroundColor = primaryColor;
  final unselectedBackgroundColor = contentBoxTwoColor;

  TextEditingController titleController = TextEditingController();

  bool isActive = true;
  late int id;
  late String type = widget.type.name;
  late String title = '';
  late String notifyAt = "one hour ago";
  late List<String> targetTimeAt = [];
  late List<String> daysOfWeek = List.empty(growable: true);

  List<Widget> targetTimeWidgets = [];
  List<String> allDays = NotificationDayType.values
      .where((type) => type != NotificationDayType.all)
      .map((type) => type.englishName)
      .toList(); // '매일'을 제외한 모든 요일의 리스트

  @override
  void initState() {
    super.initState();
    if (widget.notification != null) {
      // Notification 데이터가 넘어온 경우, UI를 해당 데이터로 초기화
      id = widget.notification!.id;
      type = widget.notification!.type;
      titleController.text = widget.notification!.title;
      title = titleController.text;
      isActive = widget.notification!.isActive;
      notifyAt = widget.notification!.notifyAt;
      if (notifyAt == 'one hour ago') {
        selectedOneHourAgo = true;
        selectedThirtyMinutesAgo = false;
        selectedOnTime = false;
      } else if (notifyAt == 'thirty minutes ago') {
        selectedOneHourAgo = false;
        selectedThirtyMinutesAgo = true;
        selectedOnTime = false;
      } else {
        selectedOneHourAgo = false;
        selectedThirtyMinutesAgo = false;
        selectedOnTime = true;
      }
      targetTimeAt = List.from(widget.notification!.targetTimeAt);
      daysOfWeek = List.from(widget.notification!.daysOfWeek);

      targetTimeWidgets = List.generate(targetTimeAt.length, (index) {
        return NotificationSettingCard(
          key: ValueKey(targetTimeAt[index]), // 시간을 고유 키로 사용
          initialTime: targetTimeAt[index],
          targetTimeAt: (newTime) => _handleTargetTimeAt(newTime, index),
        );
      });
    } else {
      _addNotificationCard();
      selectedOneHourAgo = true;
    }
  }

  // targetTime "HH : mm" -> "HH:mm" 형태로 변환
  void _handleTargetTimeAt(String time, int index) {
    setState(() {
      if (index > -1) {
        targetTimeAt[index] = (time.replaceAll(" ", ""));
      } else {
        targetTimeAt.add(time.replaceAll(" ", ""));
      }
    });
  }

  // 동적으로 NotificationSettingCard 추가
  void _addNotificationCard() {
    setState(() {
      targetTimeWidgets.add(NotificationSettingCard(
        targetTimeAt: (newTime) => _handleTargetTimeAt(newTime, -1),
      ));
    });
  }

  late NotificationApiService notificationViewModel;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    NotificationApiService notificationViewModel =
        Provider.of<NotificationApiService>(context, listen: false);

    bool isRegisterButtonEnabled() {
      return titleController.text.isNotEmpty &&
          notifyAt.isNotEmpty &&
          daysOfWeek.isNotEmpty &&
          targetTimeAt.isNotEmpty;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7FA),
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          "알림 설정",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: AppUtils.scaleSize(context, 20)),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: AppUtils.scaleSize(context, 20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppUtils.scaleSize(context, 30),
                    ),
                    TextField(
                      cursorColor: primaryColor,
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: mainTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: AppUtils.scaleSize(context, 20),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: const Color(0xff2B2D35),
                          fontSize: AppUtils.scaleSize(context, 20),
                        ),
                        hintText: "일정의 제목을 입력해주세요",
                        hintStyle: TextStyle(
                          color: const Color(0xff858998),
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scaleSize(context, 20),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          title = text;
                        });
                      },
                    ),
                    Container(
                      width: screenWidth,
                      height: AppUtils.scaleSize(context, 1.5),
                      color: titleController.text.isNotEmpty
                          ? primaryColor
                          : mainLineColor,
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 50),
                    ),
                    Text(
                      type == CardType.bloodsugar.name ? "측정 시간" : "복용 시간",
                      style: TextStyle(
                        color: const Color(0xff2B2D35),
                        fontWeight: FontWeight.bold,
                        fontSize: AppUtils.scaleSize(context, 18),
                      ),
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 10),
                    ),
                    ...targetTimeWidgets
                        .expand((widget) => [
                              widget,
                              SizedBox(height: AppUtils.scaleSize(context, 10))
                            ])
                        .toList(),
                    SizedBox(height: AppUtils.scaleSize(context, 10)),
                    type == CardType.bloodsugar.name
                        ? Container()
                        : GestureDetector(
                            onTap: _addNotificationCard,
                            child: Center(
                              child: Text(
                                "+ 알림 받을 시간 추가하기",
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppUtils.scaleSize(context, 14)),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 20),
                    ),
                    Text(
                      "알림",
                      style: TextStyle(
                        color: const Color(0xff2B2D35),
                        fontWeight: FontWeight.bold,
                        fontSize: AppUtils.scaleSize(context, 18),
                      ),
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOneHourAgo = !selectedOneHourAgo;
                              if (selectedOneHourAgo) {
                                selectedThirtyMinutesAgo = false;
                                selectedOnTime = false;
                                notifyAt = "one hour ago";
                              }
                            });
                          },
                          child: Container(
                            width: AppUtils.scaleSize(context, 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: selectedOneHourAgo
                                  ? selectedBackgroundColor
                                  : unselectedBackgroundColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppUtils.scaleSize(context, 20),
                                  vertical: AppUtils.scaleSize(context, 15)),
                              child: Center(
                                child: Text(
                                  "1시간 전",
                                  style: TextStyle(
                                      color: selectedOneHourAgo
                                          ? selectedTextColor
                                          : unselectedTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          AppUtils.scaleSize(context, 16)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedThirtyMinutesAgo =
                                  !selectedThirtyMinutesAgo;
                              if (selectedThirtyMinutesAgo) {
                                selectedOneHourAgo = false;
                                selectedOnTime = false;
                                notifyAt = "thirty minutes ago";
                              }
                            });
                          },
                          child: Container(
                            width: AppUtils.scaleSize(context, 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: selectedThirtyMinutesAgo
                                  ? selectedBackgroundColor
                                  : unselectedBackgroundColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppUtils.scaleSize(context, 20),
                                  vertical: AppUtils.scaleSize(context, 15)),
                              child: Center(
                                child: Text(
                                  "30분 전",
                                  style: TextStyle(
                                      color: selectedThirtyMinutesAgo
                                          ? selectedTextColor
                                          : unselectedTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          AppUtils.scaleSize(context, 16)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOnTime = !selectedOnTime;
                              if (selectedOnTime) {
                                selectedThirtyMinutesAgo = false;
                                selectedOneHourAgo = false;
                                notifyAt = "on time";
                              }
                            });
                          },
                          child: Container(
                            width: AppUtils.scaleSize(context, 100),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: selectedOnTime
                                  ? selectedBackgroundColor
                                  : unselectedBackgroundColor,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: AppUtils.scaleSize(context, 20),
                                  vertical: AppUtils.scaleSize(context, 15)),
                              child: Center(
                                child: Text(
                                  "정시",
                                  style: TextStyle(
                                      color: selectedOnTime
                                          ? selectedTextColor
                                          : unselectedTextColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          AppUtils.scaleSize(context, 16)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 40),
                    ),
                    Text(
                      "알림 받을 요일",
                      style: TextStyle(
                        color: const Color(0xff2B2D35),
                        fontWeight: FontWeight.bold,
                        fontSize: AppUtils.scaleSize(context, 18),
                      ),
                    ),
                    SizedBox(
                      height: AppUtils.scaleSize(context, 20),
                    ),
                    SizedBox(
                      width: screenWidth - AppUtils.scaleSize(context, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var dayType in NotificationDayType.values)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (daysOfWeek
                                      .contains(dayType.englishName)) {
                                    daysOfWeek.remove(dayType.englishName);
                                  } else {
                                    if (dayType.englishName == 'all') {
                                      // 매일과 요일을 중복으로 선택 못하도록 방지
                                      daysOfWeek.clear();
                                      daysOfWeek.add(dayType.englishName);
                                    } else {
                                      if (daysOfWeek.contains('all')) {
                                        daysOfWeek.remove('all');
                                      }
                                      daysOfWeek.add(dayType.englishName);
                                    }
                                    if (allDays.every(
                                        (day) => daysOfWeek.contains(day))) {
                                      daysOfWeek = [
                                        NotificationDayType.all.englishName
                                      ]; // 모든 요일을 'all'로 대체
                                    }
                                  }
                                });
                              },
                              child: Container(
                                width: AppUtils.scaleSize(context, 38),
                                height: AppUtils.scaleSize(context, 45),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color:
                                      daysOfWeek.contains(dayType.englishName)
                                          ? selectedBackgroundColor
                                          : backgroundColor,
                                ),
                                child: Center(
                                  child: Text(
                                    dayType.name,
                                    style: TextStyle(
                                        color: daysOfWeek
                                                .contains(dayType.englishName)
                                            ? selectedTextColor
                                            : unselectedTextColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            AppUtils.scaleSize(context, 16)),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppUtils.scaleSize(context, 70)),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (isRegisterButtonEnabled()) {
                  var notification = NotificationModel(
                    isActive: isActive,
                    type: widget.type.name,
                    title: title,
                    notifyAt: notifyAt,
                    targetTimeAt: targetTimeAt,
                    daysOfWeek: daysOfWeek,
                  );
                  if (widget.notification != null) {
                    int responseId = await notificationViewModel
                        .modifyNotification(id, notification);
                    widget.onModify!(responseId);
                  } else {
                    int responseId = await notificationViewModel
                        .recordNotification(notification);
                    widget.onRegister!(responseId);
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                width: screenWidth - AppUtils.scaleSize(context, 40),
                height: AppUtils.scaleSize(context, 56),
                margin:
                    EdgeInsets.only(bottom: AppUtils.scaleSize(context, 20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isRegisterButtonEnabled()
                      ? primaryColor
                      : const Color(0xffC9DFF9),
                ),
                child: Center(
                  child: Text(
                    "등록하기",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: AppUtils.scaleSize(context, 16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum NotificationDayType {
  mon("월"),
  tue("화"),
  wed("수"),
  thu("목"),
  fri("금"),
  sat("토"),
  sun("일"),
  all("매일");

  final String name;
  const NotificationDayType(this.name);

  String get englishName {
    switch (this) {
      case NotificationDayType.mon:
        return "mon";
      case NotificationDayType.tue:
        return "tue";
      case NotificationDayType.wed:
        return "wed";
      case NotificationDayType.thu:
        return "thu";
      case NotificationDayType.fri:
        return "fri";
      case NotificationDayType.sat:
        return "sat";
      case NotificationDayType.sun:
        return "sun";
      case NotificationDayType.all:
        return "all";
      default:
        return "";
    }
  }
}
