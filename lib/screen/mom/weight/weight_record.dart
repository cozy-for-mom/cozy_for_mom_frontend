import 'package:flutter/material.dart';
import 'package:cozy_for_mom_frontend/common/widget/month_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';

class WeightRecord extends StatefulWidget {
  const WeightRecord({super.key});

  @override
  State<WeightRecord> createState() => _WeightRecordState();
}

class _WeightRecordState extends State<WeightRecord> {
  // 텍스트 입력 필드의 내용을 제어하고 관리
  final TextEditingController _weightController = TextEditingController();
  // 포커스 관리 (사용자가 특정 위젯에 포커스를 주거나 포커스를 뺄 때 이벤트를 처리)
  final FocusNode _weightFocus = FocusNode();
  Color unitTextColor = const Color(0xffE0E0E0);

  // @override
  // void initState() {
  //   super.initState();
  //   // 포커스가 있으면 텍스트 입력 필드를 활성화하고 힌트 텍스트를 지웁니다.
  //   // 포커스가 없으면 힌트 텍스트를 다시 표시합니다.
  //   _weightFocus.addListener(() {
  //     setState(() {
  //       if (_weightFocus.hasFocus) {
  //         _weightController.clear();
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    _weightController.dispose();
    _weightFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // 현재 날짜
    String formattedDate = DateFormat('M.d E', 'ko_KR').format(now);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 47,
            width: 400, // TODO 화면 너비에 맞춘 width로 수정해야함
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
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
                            showModalBottomSheet(
                              backgroundColor: Colors.white
                                  .withOpacity(0.0), // 팝업창 자체 색 : 투명
                              context: context,
                              builder: (context) {
                                return const MonthCalendarModal();
                              },
                            );
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
                          print(
                              '알림창 아이콘 클릭'); // TODO 알림창 아이콘 onPressed{} 구현해야 함
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
                decoration: const BoxDecoration(
                    color: Colors.white60), // TODO 주간 캘린더 위젯 넣어야 함
                child: const Center(
                    child: Text(
                  '주간 캘린더',
                  style: TextStyle(fontSize: 20),
                )),
              )),
          Positioned(
            top: 205,
            left: 20,
            child: Container(
              width: 350,
              height: 86,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('나의 체중',
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18)),
                          Text('마지막 측정 3일전',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 85,
                            child: TextFormField(
                              // textAlign: TextAlign.center,
                              // showCursor: false,
                              cursorColor: const Color(0xffE0E0E0),
                              cursorHeight: 28,
                              controller: _weightController,
                              focusNode: _weightFocus,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 7),
                                  border: InputBorder.none,
                                  hintText: '00.00',
                                  hintStyle: TextStyle(
                                    color: Color(0xffE0E0E0),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                  )),
                              style: TextStyle(
                                color: unitTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 28,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  // 텍스트가 변경될 때마다 호출됨
                                  if (text.isNotEmpty) {
                                    // 텍스트가 비어있지 않으면 원하는 색상으로 변경
                                    unitTextColor =
                                        Colors.black; // 사용자가 입력한 경우의 텍스트 색
                                  } else {
                                    // 텍스트가 비어있으면 다시 기본 색상으로 변경
                                    unitTextColor = const Color(0xffE0E0E0);
                                  }
                                });
                              },
                            ),
                          ),
                          Text(
                            'kg',
                            style: TextStyle(
                                color: unitTextColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 28),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
          Positioned(
              top: 331,
              left: 20,
              child: Container(
                width: 350,
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(20)),
              ))
        ],
      ),
    );
  }
}
