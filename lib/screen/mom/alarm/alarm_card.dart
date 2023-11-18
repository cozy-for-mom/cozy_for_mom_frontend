import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';

enum CardType { bloodsugar, supplement }

class AlarmSettingCard extends StatefulWidget {
  final String text;
  final CardType type;
  const AlarmSettingCard({super.key, required this.text, required this.type});

  @override
  State<AlarmSettingCard> createState() => _AlarmSettingCardState();
}

class _AlarmSettingCardState extends State<AlarmSettingCard> {
  bool isAlarmOn = false; // 초기 알람 상태
  final List<String> timeList = [
    '매일 오전 12:00',
    '매일 오후 8:00',
    '30분 전 알림',
    '1시간 전 알림'
  ];

  @override
  Widget build(BuildContext context) {
    Widget childWiget;

    switch (widget.type) {
      case CardType.bloodsugar:
        childWiget = Text(widget.text,
            style: const TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 18));
        break;
      case CardType.supplement:
        childWiget = Row(children: [
          Text(widget.text,
              style: const TextStyle(
                  color: afterInputColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          const SizedBox(width: 7),
          Container(
            width: 57,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffFEEEEE),
                borderRadius: BorderRadius.circular(8)),
            child: const Text(
              '하루 -회',
              style: TextStyle(
                  color: Color(0xffFF9797),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          )
        ]);
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              color: Colors.transparent,
              iconWidget: Container(
                width: 120,
                decoration: const BoxDecoration(
                  color: deleteButtonColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/icons/delete.png'),
                        width: 17.5,
                        height: 18,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "삭제",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ]),
              ),
              onTap: () {
                print('"${widget.text}" 알람 삭제'); // TODO 알람 삭제 기능 구현
              },
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
                color: contentBoxTwoColor,
                borderRadius: BorderRadius.circular(20.0)),
            width: 350, // TODO 화면 너비에 맞춘 width로 수정해야함
            height: 164,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        childWiget,
                        CupertinoSwitch(
                          value: isAlarmOn,
                          onChanged: (value) {
                            setState(() {
                              isAlarmOn = value;
                            });
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: timeList.map((time) {
                        return Container(
                          padding: const EdgeInsets.only(top: 5, right: 15),
                          child: Text(
                            time,
                            style: TextStyle(
                              color:
                                  isAlarmOn ? primaryColor : offButtonTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
