import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MonthCalendar extends StatefulWidget {
  bool limitToday;
  bool firstToday;
  MonthCalendar(
      {super.key, required this.limitToday, required this.firstToday});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  DateTime _focusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final globalDate = Provider.of<MyDataModel>(context, listen: true);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
          width: screenWidth - AppUtils.scaleSize(context, 40),
          child: TableCalendar(
            focusedDay: globalDate.selectedDay,
            firstDay: widget.firstToday ? DateTime.now() : DateTime(2020),
            lastDay: widget.limitToday
                ? DateTime.now()
                : DateTime(2050), //DateTime.now().add(Duration(days: 1825)),
            selectedDayPredicate: (date) {
              return isSameDay(date, globalDate.selectedDay);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                globalDate.updateSelectedDay(selectedDay);
                _focusedDay = focusedDay;
              });
            },
            locale: 'ko-KR',
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: AppUtils.scaleSize(context, 14),
              ),
              defaultTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: AppUtils.scaleSize(context, 14),
              ),
              outsideTextStyle: TextStyle(
                color: Color(0xffE3E3E3),
                fontWeight: FontWeight.w500,
                fontSize: AppUtils.scaleSize(context, 14),
              ),
              todayDecoration: const BoxDecoration(
                color: Color.fromRGBO(92, 166, 248, 128), // 오늘 날짜 마크 색상
                shape: BoxShape.circle, // 원 모양 마크
              ),
              selectedDecoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: mainTextColor,
              ),
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: mainTextColor,
              ),
              titleCentered: true,
              formatButtonVisible: false, // 디폴트로 2weeks 버튼 나오는거
              titleTextStyle: TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scaleSize(context, 20)),
              headerPadding: EdgeInsets.fromLTRB(
                  AppUtils.scaleSize(context, 70),
                  0,
                  AppUtils.scaleSize(context, 70),
                  AppUtils.scaleSize(context, 20)),
              titleTextFormatter: (date, locale) {
                final year = DateFormat('y', 'en_US').format(date);
                final month = DateFormat('M', 'en_US').format(date);
                return '$year.$month';
              }, // 타이틀 텍스트를 무엇으로 할 것인지 지정
            ),
            daysOfWeekHeight: 34,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: offButtonTextColor,
                fontSize: AppUtils.scaleSize(context, 16),
              ),
              weekendStyle: TextStyle(
                color: offButtonTextColor,
                fontSize: AppUtils.scaleSize(context, 16),
              ),
            ),
          )),
    );
  }
}

class MonthCalendarModal extends StatelessWidget {
  bool limitToday;
  bool firstToday;
  MonthCalendarModal(
      {super.key, this.limitToday = false, this.firstToday = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final globalDate = Provider.of<MyDataModel>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: AlignmentDirectional.centerEnd,
            margin: EdgeInsets.only(bottom: AppUtils.scaleSize(context, 15)),
            height: AppUtils.scaleSize(context, 20),
            child: IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              padding: EdgeInsets.all(AppUtils.scaleSize(context, 20)),
              width: screenWidth,
              height: screenHeight * (0.5),
              child: ChangeNotifierProvider.value(
                value: globalDate,
                child: MonthCalendar(
                    limitToday: limitToday, firstToday: firstToday),
              ),
            ),
          )
        ],
      ),
    );
  }
}
