import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/common/widget/floating_button.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:cozy_for_mom_frontend/model/baby_growth_model.dart';
import 'package:cozy_for_mom_frontend/screen/baby/grow_report_register.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_detail_screen.dart';
import 'package:cozy_for_mom_frontend/service/baby/baby_growth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

class BabyGrowthReportListScreen extends StatefulWidget {
  const BabyGrowthReportListScreen({super.key});

  @override
  State<BabyGrowthReportListScreen> createState() =>
      _BabyGrowthReportListScreenState();
}

class _BabyGrowthReportListScreenState
    extends State<BabyGrowthReportListScreen> {
  late Future<List<BabyProfileGrowth>> growths;

  @override
  void initState() {
    super.initState();
    growths = BabyGrowthApiService().getBabyProfileGrowths(null, 10);
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
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
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
                    if (nextCheckUpDate != null)
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            context: context,
                            builder: (context) {
                              return const MonthCalendarModal();
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              "2023년 10월 27일", // TODO 수정해야함
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 13,
                              color: Color(0xff858998),
                            ),
                          ],
                        ),
                      ),
                    if (nextCheckUpDate == null)
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            context: context,
                            builder: (context) {
                              return const MonthCalendarModal();
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
              future: growths,
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
                          top: 18.0,
                          left: 3,
                          right: 3,
                        ),
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final report = snapshot.data[index];
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
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                                    fontWeight: FontWeight.w600,
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
                                                      BorderRadius.circular(10),
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
                                        height: 15,
                                      ),
                                      const Divider(
                                        color: Color(0xffE1E1E7),
                                        thickness: 1.0,
                                      )
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
      ),
      floatingActionButton: CustomFloatingButton(
        pressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const GrowReportRegister()));
        },
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const MaterialApp(home: BabyGrowthReportListScreen()));
  initializeDateFormatting("ko_kr");
}
