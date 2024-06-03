import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_time_correction_modal.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SupplementCard extends StatefulWidget {
  final int supplementId;
  final String name;
  final int targetCount;
  int realCount;
  List<DateTime> takeTimes;
  List<int> recordIds;

  SupplementCard(
      {super.key,
      required this.supplementId,
      required this.name,
      required this.targetCount,
      required this.realCount,
      required this.takeTimes,
      required this.recordIds});

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
    List<DateTime> sortedTakeTimes = widget.takeTimes
      ..sort((a, b) => a.compareTo(b));
    return SingleChildScrollView(
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
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext buildContext) {
                        return DeleteModal(
                          text: '등록된 영양제를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                          title: '영양제가',
                          tapFunc: () => supplementApi
                              .deleteSupplement(widget.supplementId),
                        );
                      },
                    );
                  },
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
              ),
            ),
          ],
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
                                    int id = widget.recordIds[index];
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SelectBottomModal(
                                              selec1: '시간 수정하기',
                                              selec2: '기록 삭제하기',
                                              tap1: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return SupplementModal(
                                                        id: id,
                                                        name: widget.name);
                                                  },
                                                );
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
                                      ? DateFormat('HH:mm')
                                          .format(sortedTakeTimes[index])
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
        ),
      ),
    );
  }
}
