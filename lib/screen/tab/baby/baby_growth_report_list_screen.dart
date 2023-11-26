import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/screen/tab/baby/baby_growth_report_model.dart';
import 'package:flutter/material.dart';

class BabyGrowthReportListScreen extends StatelessWidget {
  const BabyGrowthReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<BabyGrowthReportModel> reportList = [
      BabyGrowthReportModel(
        id: 1,
        title: "10월 28일 기록!",
        content: "랄라랄ㄹ",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXlfvpIbg18RGojIQN51ylWmN5RObmyCOwumi6b-iXA&s",
        dateTime: DateTime.now(),
      ),
      BabyGrowthReportModel(
        id: 2,
        title: "10월 27일 기록!",
        content: "랄라랄ffffffㄹ",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXlfvpIbg18RGojIQN51ylWmN5RObmyCOwumi6b-iXA&s",
        dateTime: DateTime.now(),
      ),
      BabyGrowthReportModel(
        id: 2,
        title: "10월 27일 기록!",
        content: "랄라랄ffffffㄹ",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXlfvpIbg18RGojIQN51ylWmN5RObmyCOwumi6b-iXA&s",
        dateTime: DateTime.now(),
      ),
      BabyGrowthReportModel(
        id: 2,
        title: "10월 27일 기록!",
        content: "랄라랄ffffffㄹ",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXlfvpIbg18RGojIQN51ylWmN5RObmyCOwumi6b-iXA&s",
        dateTime: DateTime.now(),
      ),
      BabyGrowthReportModel(
        id: 2,
        title: "10월 27일 기록!",
        content: "랄라랄ffffffㄹ",
        imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXlfvpIbg18RGojIQN51ylWmN5RObmyCOwumi6b-iXA&s",
        dateTime: DateTime.now(),
      ),
    ];
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
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "다음 검진일",
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "2023년 10월 27일",
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          ">",
                          style: TextStyle(color: Color(0xff858998)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  itemCount: reportList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final report = reportList[index];
                    final dateTime = report.dateTime;
                    return InkWell(
                      onTap: () {
                        print("card 클릭"); // TODO 상세 조회페이지로 이동
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.title,
                                        style: const TextStyle(
                                          fontSize: 16,
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
                                          fontSize: 16,
                                          color: Color(0xffAAAAAA),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        report.content,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff858998),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      report.imageUrl,
                                      width: 79,
                                      height: 79,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Divider(
                                  color: Color(0xffE1E1E7),
                                  thickness: 2.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const MaterialApp(home: BabyGrowthReportListScreen()));
}
