import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/model/supplement_model.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // 한국어 로케일을 사용하기 위해 추가

void main() {
  initializeDateFormatting('ko_KR', null).then((_) {
    // 'ko_KR'는 한국어 로케일
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SupplementRecord(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(), // 필요한 테마 설정
        fontFamily: 'Pretendard',
      ),
    );
  }
}

class SupplementRecord extends StatefulWidget {
  const SupplementRecord({Key? key}) : super(key: key);

  @override
  State<SupplementRecord> createState() => _SupplementRecordState();
}

class _SupplementRecordState extends State<SupplementRecord> {
  List<PregnantSupplement> supplements = [
    PregnantSupplement(
        supplementName: '철분제', targetCount: 2, realCount: 0, takeTimes: []),
    PregnantSupplement(
        supplementName: '비타민B', targetCount: 3, realCount: 0, takeTimes: []),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);

    return Scaffold(
      backgroundColor: backgroundColor,
      // Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 47,
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop(); // 현재 화면을 닫음
                      },
                    ),
                    Row(
                      children: [
                        Text(formattedDate,
                            style: const TextStyle(
                                color: Color(0xff2B2D35),
                                fontWeight: FontWeight.w600,
                                fontSize: 18)),
                        IconButton(
                          alignment: AlignmentDirectional.centerStart,
                          icon: const Icon(Icons.expand_more),
                          onPressed: () {
                            print('월간 캘린더 팝업창 뜨기');
                          },
                        ),
                      ],
                    ),
                    IconButton(
                        icon: const Image(
                            image: AssetImage('assets/images/icons/alert.png'),
                            height: 32,
                            width: 32),
                        onPressed: () {
                          print('알림창 아이콘 클릭');
                        })
                  ]),
            ),
          ),
          Positioned(
              top: 102,
              left: 20,
              child: Container(
                width: 350,
                height: 63,
                decoration: const BoxDecoration(color: Colors.white60),
                child: const Center(
                    child: Text(
                  '주간 캘린더',
                  style: TextStyle(fontSize: 20),
                )),
              )),
          Positioned(
            top: 203,
            left: 20,
            child: Column(
              children: supplements.map((supplement) {
                return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: supplementCard(
                      name: supplement.supplementName,
                      targetCount: supplement.targetCount,
                      realCount: supplement.realCount,
                      takeTimes: supplement.takeTimes,
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}