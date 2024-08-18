import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/notification_model.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_setting.dart';
import 'package:cozy_for_mom_frontend/screen/notification/notification_setting_screen.dart';
import 'package:cozy_for_mom_frontend/service/notification/notification_domain_api_service.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/screen/notification/alarm_card.dart';
import 'package:provider/provider.dart';

class SupplementAlarm extends StatefulWidget {
  const SupplementAlarm({super.key});

  @override
  State<SupplementAlarm> createState() => _SupplementAlarmState();
}

class _SupplementAlarmState extends State<SupplementAlarm> {
  late NotificationApiService notificationViewModel;
  late List<NotificationModel> notifications;
  late List<int> notificationIds;

  void changeActive() async {
    setState(() {});
  }

  void deleteNotification(int id) {
    setState(() {
      notificationIds.remove(id);
    });
  }

  void modifyNotification(int id) {
    setState(() {
      notificationIds.remove;
      notificationIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    NotificationApiService notificationViewModel =
        Provider.of<NotificationApiService>(context, listen: false);
    return FutureBuilder(
        future: notificationViewModel.getNotifications(context, 'supplement'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 비동기 작업이 완전히 완료되었는지 확인하는 조건
            if (snapshot.hasData) {
              notifications = snapshot.data! as List<NotificationModel>;
              notificationIds =
                  notifications.map((notification) => notification.id).toList();
            }
          }
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.white,
            ));
          }
          return Positioned(
            top: AppUtils.scaleSize(context, 90),
            left: 0,
            right: 0,
            child: notifications.isEmpty
                ? Column(children: [
                    SizedBox(
                        height: screenHeight * (0.55),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: const AssetImage(
                                      'assets/images/icons/notification_off.png'),
                                  width: AppUtils.scaleSize(context, 50),
                                  height: AppUtils.scaleSize(context, 52)),
                              SizedBox(height: AppUtils.scaleSize(context, 7)),
                              Text('알림을 등록해 보세요!',
                                  style: TextStyle(
                                      color: const Color(0xff9397A4),
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          AppUtils.scaleSize(context, 14))),
                            ])),
                  ])
                : SizedBox(
                    height: screenHeight - AppUtils.scaleSize(context, 200),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: notifications.map<Widget>((notification) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationSettingScreen(
                                    type: CardType.bloodsugar,
                                    notification: notification,
                                    onModify: modifyNotification,
                                  ),
                                ),
                              );
                            },
                            child: AlarmSettingCard(
                              notification: notification,
                              onActiveChanged: changeActive,
                              onDelete: deleteNotification,
                            ),
                          );
                        }).toList()
                          ..add(SizedBox(
                              height: screenHeight *
                                  (1 / 8))), // 리스트 끝에 SizedBox 추가
                      ),
                    ),
                  ),
          );
        });
  }
}
