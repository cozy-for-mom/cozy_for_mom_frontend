import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class supplementCard extends StatefulWidget {
  final String name;
  final int targetCount;
  int realCount;
  List<DateTime> takeTimes;

  supplementCard(
      {required this.name,
      required this.targetCount,
      required this.realCount,
      required this.takeTimes});

  @override
  _supplementCardState createState() => _supplementCardState();
}

class _supplementCardState extends State<supplementCard> {
  void _handleButtonClick() {
    // 클릭한 시간을 현재 시간으로 설정하는 함수
    DateTime currentTime = DateTime.now();

    // '먹었어요' 버튼 클릭 시 realCount 증가 및 클릭한 시간 저장 (상태관리)
    setState(() {
      widget.realCount++;
      widget.takeTimes.add(currentTime);
    });
  }

  double calculateCardHeight(int itemCount) {
    double buttonHeight = 36;
    double spacingHeight = 8;
    return itemCount * (buttonHeight + spacingHeight) + 40;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: 350,
        height: calculateCardHeight(widget.targetCount),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 섭취 완료 여부에 따라 image _ on/off 조건문 (~? ~:~) 적용
              Row(children: [
                Image(
                    image: AssetImage(
                      widget.targetCount == widget.realCount
                          ? 'assets/images/icons/take_on.png'
                          : 'assets/images/icons/take_off.png',
                    ),
                    width: 20,
                    height: 20),
                const SizedBox(width: 10),
                Text(widget.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)),
                const SizedBox(width: 5),
                Container(
                  width: 57,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color(0xffFEEEEE),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    '하루 ${widget.targetCount}회',
                    style: const TextStyle(
                        color: Color(0xffFF9797),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                )
              ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.targetCount,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: InkWell(
                        onTap: () {
                          // 버튼이 클릭되었을 때 수행할 동작 (텍스트는 현재 시간으로 바뀌며 컨테이너 배경색 변경)
                          _handleButtonClick();
                        },
                        child: Container(
                          width: 106,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: widget.realCount > index
                                  ? primaryColor
                                  : const Color(0xffF0F0F5),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                              widget.realCount > index
                                  ? '${DateFormat('HH:mm').format(widget.takeTimes[index])}'
                                  : '먹었어요',
                              style: TextStyle(
                                  color: widget.realCount > index
                                      ? Colors.white
                                      : const Color(0xff858998),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                        ),
                      ),
                    ),
                  )),
            ]),
      ),
    );
  }
}
