import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_complite_alert.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/service/mom_supplement_api_service.dart';

class SupplementCard extends StatefulWidget {
  final String name;
  final int targetCount;
  int realCount;
  List<DateTime> takeTimes;
  List<int> ids;

  SupplementCard(
      {super.key,
      required this.name,
      required this.targetCount,
      required this.realCount,
      required this.takeTimes,
      required this.ids});

  @override
  _SupplementCardState createState() => _SupplementCardState();
}

class _SupplementCardState extends State<SupplementCard> {
  // 영양제 섭취 횟수에 따라 Card 위젯 height 동적으로 설정
  double calculateCardHeight(int itemCount) {
    double buttonHeight = 36;
    double spacingHeight = 8;
    return itemCount * (buttonHeight + spacingHeight) + 40;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    late DateTime currentTime;
    SupplementApiService supplementApi = SupplementApiService();
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: screenWidth - 40,
        height: calculateCardHeight(widget.targetCount),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                        onTap: widget.realCount > index
                            ? () {
                                currentTime = DateTime.now();
                                int id = widget.ids[index];
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectBottomModal(
                                          selec1: '시간 수정하기',
                                          selec2: '기록 삭제하기',
                                          tap1: () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              supplementApi
                                                  .modifySupplementIntake(id,
                                                      widget.name, currentTime);
                                            });
                                          },
                                          tap2: () {
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return DeleteModal(
                                                    text:
                                                        '기록된 시간을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                    title: '기록이',
                                                    tapFunc: () => supplementApi
                                                        .deleteSupplementIntake(
                                                            id),
                                                  );
                                                });
                                          });
                                    });
                              }
                            : () {
                                print('${widget.realCount} $index');

                                setState(() {
                                  currentTime = DateTime.now();
                                  // TODO 아래 2줄 : 영양제 섭취 기록 시, 화면 리렌더링하는 방법 찾으면 제거해도 되는 코드
                                  widget.realCount++;
                                  widget.takeTimes.add(currentTime);
                                  supplementApi.recordSupplementIntake(
                                      widget.name, currentTime);
                                });
                              },
                        child: Container(
                          width: 106,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: widget.realCount > index
                                  ? primaryColor
                                  : offButtonColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                              widget.realCount > index
                                  ? '${DateFormat('HH:mm').format(widget.takeTimes[index])}'
                                  : '먹었어요',
                              style: TextStyle(
                                  color: widget.realCount > index
                                      ? Colors.white
                                      : offButtonTextColor,
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
