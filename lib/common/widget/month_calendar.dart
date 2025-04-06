import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: SizedBox(
          width: screenWidth - 40.w,
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
            rowHeight: isTablet? 35.w : 40.w,
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: min(14.sp, 24),
              ),
              defaultTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: min(14.sp, 24),
              ),
              todayTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: min(14.sp, 24),
                color: Colors.white,
              ),
              selectedTextStyle: TextStyle(
                fontSize: min(14.sp, 24),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              outsideTextStyle: TextStyle(
                color: const Color(0xffE1E1E7),
                fontWeight: FontWeight.w500,
                fontSize: min(14.sp, 24),
              ),
              disabledTextStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: min(14.sp, 24),
                color: const Color(0xffE1E1E7),
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
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: mainTextColor,
                size: 20.w,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: mainTextColor,
                size: 20.w,
              ),
              titleCentered: true,
              formatButtonVisible: false, // 디폴트로 2weeks 버튼 나오는거
              titleTextStyle: TextStyle(
                color: mainTextColor,
                fontWeight: FontWeight.w600,
                fontSize: min(20.sp, 30),
              ),
              headerPadding:
                  EdgeInsets.fromLTRB(min(70.w, 110), 0, min(70.w, 110), 20.w),
              titleTextFormatter: (date, locale) {
                final year = DateFormat('y', 'en_US').format(date);
                final month = DateFormat('M', 'en_US').format(date);
                return '$year.$month';
              }, // 타이틀 텍스트를 무엇으로 할 것인지 지정
            ),
            daysOfWeekHeight: 34.w,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: min(16.sp, 26),
              ),
              weekendStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: min(16.sp, 26),
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
    final isTablet = screenWidth > 600;
    final paddingValue = isTablet ? 30.w : 20.w;

    return Column(
      children: [
        Container(
          alignment: AlignmentDirectional.centerEnd,
          margin: EdgeInsets.only(bottom: min(15.w, 15)),
          height: 20.w,
          child: IconButton(
            icon: const Icon(Icons.close),
            iconSize: min(20.w, 40),
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
            },
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
          child: Container(
            alignment: Alignment.topCenter,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            width: screenWidth,
            height: min(380.w, 710),
            child: ChangeNotifierProvider.value(
              value: globalDate,
              child:
                  MonthCalendar(limitToday: limitToday, firstToday: firstToday),
            ),
          ),
        )
      ],
    );
  }
}
