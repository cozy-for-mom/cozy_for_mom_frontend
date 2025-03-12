import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cozy_for_mom_frontend/common/widget/delete_modal.dart';
import 'package:cozy_for_mom_frontend/common/widget/select_bottom_modal.dart';
import 'package:cozy_for_mom_frontend/service/mom/mom_supplement_api_service.dart';
import 'package:cozy_for_mom_frontend/screen/mom/supplement/supplement_time_correction_modal.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SupplementCard extends StatefulWidget {
  final int supplementId;
  final String name;
  final int targetCount;
  int realCount;
  List<DateTime> takeTimes;
  List<int> recordIds;
  final Function(int) onDelete;
  final Function(DateTime) onUpdate;

  SupplementCard({
    super.key,
    required this.supplementId,
    required this.name,
    required this.targetCount,
    required this.realCount,
    required this.takeTimes,
    required this.recordIds,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  _SupplementCardState createState() => _SupplementCardState();
}

class _SupplementCardState extends State<SupplementCard> {
  // 영양제 섭취 횟수에 따라 Card 위젯 height 동적으로 설정
  double calculateCardHeight(BuildContext context, int itemCount) {
    double buttonHeight = 36;
    double spacingHeight = 8;
    return (itemCount * (buttonHeight + spacingHeight) + 40).w;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    late DateTime currentTime;
    SupplementApiService supplementApi = SupplementApiService();
    final globalData = Provider.of<MyDataModel>(context, listen: false);
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    List<DateTime> sortedTakeTimes = widget.takeTimes
      ..sort((a, b) => a.compareTo(b));
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        child: Slidable(
          key: ValueKey(widget.supplementId),  // 기존 State가 다음 아이템에 붙어서 슬라이드 상태가 이어지는 현상 방지
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              CustomSlidableAction(
                padding: EdgeInsets.zero,
                foregroundColor: deleteButtonColor,
                autoClose: true,
                flex: 1,
                onPressed: (context) {
                  // 삭제 다이얼로그 띄우기
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext buildContext) {
                        return DeleteModal(
                          text: '등록된 영양제를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                          title: '영양제가',
                          tapFunc: () async {
                            await supplementApi.deleteSupplement(
                                context, widget.supplementId);
                            widget.onDelete(
                                widget.supplementId); // 상태 업데이트를 상위 위젯에 전달
                            setState(() {
                        Slidable.of(buildContext)?.close();
                            });
                          },
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.transparent,
                child: Container(
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: deleteButtonColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.w),
                      bottomRight: Radius.circular(20.w),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext buildContext) {
                        return DeleteModal(
                          text: '등록된 영양제를 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                          title: '영양제가',
                          tapFunc: () async {
                            await supplementApi.deleteSupplement(
                                context, widget.supplementId);
                            widget.onDelete(
                                widget.supplementId); // 상태 업데이트를 상위 위젯에 전달
                            setState(() {
                        Slidable.of(buildContext)?.close();
                            });
                          },
                        );
                      },
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: const AssetImage(
                              'assets/images/icons/delete.png'),
                          width: min(17.5.w, 27.5),
                          height: min(18.w, 28),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          "삭제",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: min(14.sp, 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.w),
              color: contentBoxTwoColor,
              width: screenWidth - 2 * paddingValue,
              height: calculateCardHeight(context, widget.targetCount),
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
                          width: min(20.w, 30),
                          height: min(20.w, 30)),
                      SizedBox(width: 10.w),
                      Text(widget.name,
                          style: TextStyle(
                              color: afterInputColor,
                              fontWeight: FontWeight.w600,
                              fontSize: min(18.sp, 28))),
                      SizedBox(width: 7.w),
                      Container(
                        height: 22.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                            color: const Color(0xffFEEEEE),
                            borderRadius: BorderRadius.circular(8.w)),
                        child: Text(
                          '하루 ${widget.targetCount}회',
                          style: TextStyle(
                              color: const Color(0xffFF9797),
                              fontWeight: FontWeight.w600,
                              fontSize: min(12.sp, 22)),
                        ),
                      )
                    ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.targetCount,
                          (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.w),
                            child: InkWell(
                              onTap: widget.realCount > index
                                  ? () {
                                      int id = widget.recordIds[index];
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0.0,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SelectBottomModal(
                                              selec1: '시간 수정하기',
                                              selec2: '기록 삭제하기',
                                              tap1: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return SupplementModal(
                                                      id: id,
                                                      name: widget.name,
                                                    );
                                                  },
                                                ).then((updatedData) {
                                                  if (updatedData != null) {
                                                    widget
                                                        .onUpdate(updatedData);
                                                  }
                                                });
                                              },
                                              tap2: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return DeleteModal(
                                                      text:
                                                          '기록된 시간을 삭제하시겠습니까?\n이 과정은 복구할 수 없습니다.',
                                                      title: '기록이',
                                                      tapFunc: () async {
                                                        await supplementApi
                                                            .deleteSupplementIntake(
                                                                context, id);
                                                        setState(() {
                                                          widget.realCount--;
                                                          widget.takeTimes
                                                              .removeAt(index);
                                                          widget.recordIds
                                                              .removeAt(index);
                                                        });
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          });
                                    }
                                  : () async {
                                      currentTime = DateTime.parse(
                                        '${globalData.selectedDate.toIso8601String().split('T')[0]} ${DateTime.now().toIso8601String().split('T')[1].substring(0, 12)}',
                                      );

                                      int? intakeId = await supplementApi
                                          .recordSupplementIntake(context,
                                              widget.name, currentTime);
                                      setState(() {
                                        widget.realCount++;
                                        widget.takeTimes.add(currentTime);
                                        widget.recordIds.add(intakeId!);
                                      });
                                    },
                              child: Container(
                                width: 126.w - paddingValue,
                                height: 36.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: widget.realCount > index
                                        ? primaryColor
                                        : offButtonColor,
                                    borderRadius: BorderRadius.circular(20.w)),
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
                                        fontSize: min(16.sp, 26))),
                              ),
                            ),
                          ),
                        )),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
