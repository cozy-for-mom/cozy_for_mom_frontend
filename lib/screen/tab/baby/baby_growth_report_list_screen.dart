import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/extension/pair.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/screen/main_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_detail_screen.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_main_screen.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class BabyGrowthReportListScreen extends StatefulWidget {
  const BabyGrowthReportListScreen({super.key});

  @override
  State<BabyGrowthReportListScreen> createState() =>
      _BabyGrowthReportListScreenState();
}

class _BabyGrowthReportListScreenState
    extends State<BabyGrowthReportListScreen> {
  DateFormat dateFormat = DateFormat('yyyy년 MM월 dd일');
  late Future<Pair<List<BabyProfileGrowth>, DateTime?>> data;
  DateFormat dateFormatForString = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    data = BabyGrowthApiService().getBabyProfileGrowths(null, 10);
  }

  @override
  Widget build(BuildContext context) {
    DateTime? nextCheckUpDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "성장 보고서",
          style: TextStyle(
            color: mainTextColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          color: mainTextColor,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const MainScreen(selectedIndex: 0)),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        pressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const GrowReportRegister(babyProfileGrowth: null),
            ),
          );
        },
      ),
      body: Consumer<MyDataModel>(builder: (context, globalData, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF0F0F5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "다음 검진일",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      if (nextCheckUpDate != "")
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                              context: context,
                              builder: (context) {
                                List<String> selectedNotifications = [];

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    void toggleOffNotification(
                                        String notification) {
                                      setState(() {
                                        if (selectedNotifications
                                            .contains(notification)) {
                                          selectedNotifications
                                              .remove(notification);
                                        }
                                      });
                                    }

                                    void toggleNotification(
                                        String notification) {
                                      setState(() {
                                        if (selectedNotifications
                                            .contains(notification)) {
                                          selectedNotifications
                                              .remove(notification);
                                        } else {
                                          selectedNotifications
                                              .add(notification);
                                          if (notification != 'none') {
                                            toggleOffNotification("none");
                                          } else {
                                            toggleOffNotification("on day");
                                            toggleOffNotification(
                                                "one day ago");
                                            toggleOffNotification(
                                                "two day ago");
                                            toggleOffNotification(
                                                "one week ago");
                                          }
                                        }
                                      });
                                    }

                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          MonthCalendarModal(),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Divider(
                                              height: 20,
                                              thickness: 1,
                                              color: Color(0xffE2E2E2),
                                            ),
                                          ),
                                          const Text(
                                            "알림",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                NotificationOption(
                                                    title: '당일 정오',
                                                    isSelected:
                                                        selectedNotifications
                                                            .contains("on day"),
                                                    onTap: () => {
                                                          toggleNotification(
                                                              "on day")
                                                        }),
                                                NotificationOption(
                                                  title: '하루 전',
                                                  isSelected:
                                                      selectedNotifications
                                                          .contains(
                                                              "one day ago"),
                                                  onTap: () =>
                                                      toggleNotification(
                                                          "one day ago"),
                                                ),
                                                NotificationOption(
                                                  title: '이틀 전',
                                                  isSelected:
                                                      selectedNotifications
                                                          .contains(
                                                              "two day ago"),
                                                  onTap: () =>
                                                      toggleNotification(
                                                          "two day ago"),
                                                ),
                                                NotificationOption(
                                                  title: '일주일 전',
                                                  isSelected:
                                                      selectedNotifications
                                                          .contains(
                                                              "one week ago"),
                                                  onTap: () =>
                                                      toggleNotification(
                                                          "one week ago"),
                                                ),
                                                NotificationOption(
                                                  title: '설정 안 함',
                                                  isSelected:
                                                      selectedNotifications
                                                          .contains("none"),
                                                  onTap: () =>
                                                      toggleNotification(
                                                          "none"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          InkWell(
                                            onTap: () async {
                                              await BabyGrowthApiService()
                                                  .registerNotificationExaminationDate(
                                                      dateFormatForString
                                                          .format(globalData
                                                              .selectedDate),
                                                      selectedNotifications);
                                              if (mounted) {
                                                // 비동기에서 context 관련 메소드 쓸 때, mounted로 한번 체크
                                                Navigator.pop(context, true);
                                              }
                                            },
                                            child: Container(
                                              width: 350,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ).then((value) {
                              if (value == true) {
                                setState(() {
                                  data = BabyGrowthApiService()
                                      .getBabyProfileGrowths(null, 10);
                                });
                              }
                            });
                          },
                          child: Row(
                            children: [
                              FutureBuilder(
                                  future: data,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.second != null) {
                                        return Text(dateFormat
                                            .format(snapshot.data.second));
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xff858998),
                              ),
                            ],
                          ),
                        ),
                      if (nextCheckUpDate == "")
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              context: context,
                              builder: (context) {
                                return MonthCalendarModal();
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Text(
                                "검진일 등록하기",
                                style: TextStyle(color: Color(0xff858998)),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 13,
                                color: Color(0xff858998),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder(
                future: data,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            left: 3,
                            right: 3,
                          ),
                          child: ListView.builder(
                            itemCount: snapshot.data.first.length,
                            itemBuilder: (BuildContext context, int index) {
                              final report = snapshot.data.first[index];
                              final dateTime = report.date;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BabyGrowthReportDetailScreen(
                                        babyProfileGrowthId: report.id,
                                      ),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 27.0, vertical: 5.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    report.title,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff2B2D35),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${dateTime.year}. ${dateTime.month}. ${dateTime.day}.",
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xffAAAAAA),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    report.diary,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xff858998),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Image.network(
                                                    report.growthImageUrl,
                                                    width: 79,
                                                    height: 79,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Divider(
                                          color: Color(0xffE1E1E7),
                                          thickness: 1.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(
                                "assets/images/icons/diary_inactive.png"),
                            width: 45.31,
                            height: 44.35,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "태아의 검진기록을 입력해보세요!",
                            style: TextStyle(
                              color: Color(0xff9397A4),
                            ),
                          ),
                          SizedBox(
                            height: 140,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class NotificationOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: isSelected ? primaryColor : const Color(0xffF0F0F5),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
