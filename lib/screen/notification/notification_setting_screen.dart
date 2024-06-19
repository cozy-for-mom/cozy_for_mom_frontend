import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/notification/notification_setting_card_widget.dart';
import 'package:flutter/material.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  var selectedOneHourAgo = true;
  var selectedThirtyMinutesAgo = false;
  var selectedOnHour = false;

  final selectedTextColor = Colors.white;
  final unselectedTextColor = const Color(0xff858998);
  final selectedBackgroundColor = primaryColor;
  final unselectedBackgroundColor = Colors.white;

  List<NotificationDayType> selectedDayList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F7FA),
        elevation: 0,
        title: const Text(
          "알림 설정",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const TextField(
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffE1E1E7),
                        width: 2,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xff2B2D35),
                      fontSize: 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    hintText: "일정의 제목을 입력해주세요",
                    hintStyle: TextStyle(
                      color: Color(0xff858998),
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "알림 받을 시간", // TODO 혈당-측정 시간, 영양제-복용 시간으로 바꾸기
                  style: TextStyle(
                    color: Color(0xff2B2D35),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const NotificationSettingCard(),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "+ 알림 받을 시간 추가하기",
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "알림",
                  style: TextStyle(
                    color: Color(0xff2B2D35),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                            selectedOnHour = false;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: selectedOneHourAgo
                              ? selectedBackgroundColor
                              : unselectedBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Center(
                            child: Text(
                              "1시간 전",
                              style: TextStyle(
                                color: selectedOneHourAgo
                                    ? selectedTextColor
                                    : unselectedTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedThirtyMinutesAgo = !selectedThirtyMinutesAgo;
                          if (selectedThirtyMinutesAgo) {
                            selectedOneHourAgo = false;
                            selectedOnHour = false;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: selectedThirtyMinutesAgo
                              ? selectedBackgroundColor
                              : unselectedBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Center(
                            child: Text(
                              "30분 전",
                              style: TextStyle(
                                color: selectedThirtyMinutesAgo
                                    ? selectedTextColor
                                    : unselectedTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOnHour = !selectedOnHour;
                          if (selectedOnHour) {
                            selectedThirtyMinutesAgo = false;
                            selectedOneHourAgo = false;
                          }
                        });
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: selectedOnHour
                              ? selectedBackgroundColor
                              : unselectedBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Center(
                            child: Text(
                              "정시",
                              style: TextStyle(
                                color: selectedOnHour
                                    ? selectedTextColor
                                    : unselectedTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "알림 받을 요일",
                  style: TextStyle(
                    color: Color(0xff2B2D35),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var dayType in NotificationDayType.values)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDayList.contains(dayType)
                                ? selectedDayList.remove(dayType)
                                : selectedDayList.add(dayType);
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: selectedDayList.contains(dayType)
                                ? selectedBackgroundColor
                                : unselectedBackgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              dayType.name,
                              style: TextStyle(
                                color: selectedDayList.contains(dayType)
                                    ? selectedTextColor
                                    : unselectedTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Container(
              width: 350,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: primaryColor,
              ),
              child: const Center(
                child: Text(
                  "등록하기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum NotificationDayType {
  monday("월"),
  tuesday("화"),
  wednesday("수"),
  thursday("목"),
  friday("금"),
  saturday("토"),
  sunday("일"),
  everyday("매일");

  final String name;
  const NotificationDayType(this.name);
}

void main() {
  // 'ko_KR'는 한국어 로케일
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cozy For Mom',
      home: const NotificationSettingScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(), // 필요한 테마 설정
        fontFamily: 'Pretendard',
      ),
    );
  }
}
