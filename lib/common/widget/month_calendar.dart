import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(MaterialApp(
//     home: MonthCalendar(),
//   ));
// }

class MonthCalendar extends StatefulWidget {
  const MonthCalendar({super.key});

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Widget>> _events = {
    DateTime.now(): [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: 390,
          child: TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            eventLoader: (date) => _events[date] ?? [],
            selectedDayPredicate: (date) {
              // 선택한 날짜에 마크가 있도록 설정
              return isSameDay(date, _selectedDay);
            },
            onDaySelected: (date, events) {
              setState(() {
                // 사용자가 다른 날짜를 클릭하면 마크를 업데이트
                _selectedDay = date;
              });
            },
            locale: 'ko-KR',
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: Color(0xff858998),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              defaultTextStyle: TextStyle(
                color: Color(0xff858998),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              outsideTextStyle: TextStyle(
                color: Color(0xffE3E3E3),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromRGBO(92, 166, 248, 128), // 오늘 날짜의 마크 색상
                shape: BoxShape.circle, // 원 모양의 마크
              ),
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              rightChevronIcon: const Icon(
                Icons.chevron_right,
                color: textColor,
              ), // 월을 우측으로 넘기는 버튼 아이콘 지정
              leftChevronIcon: const Icon(
                Icons.chevron_left,
                color: textColor,
              ), // 월을 좌측으로 넘기는 버튼 아이콘 지정
              titleCentered: true, // 타이틀을 센터로 설정할 것인지 여부 (true/false)
              formatButtonVisible: false, // 디폴트로 2weeks 버튼 나오는거
              titleTextStyle: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20), // 타이틀의 텍스트 스타일 지정 (Textstyle 객체)
              headerPadding: const EdgeInsets.fromLTRB(70, 0, 70, 20),
              titleTextFormatter: (date, locale) {
                final year = DateFormat('y', 'en_US').format(date);
                final month = DateFormat('M', 'en_US').format(date);
                return '$year.$month';
              }, // 타이틀 텍스트를 무엇으로 할 것인지 지정
            ),
            daysOfWeekHeight: 34,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Color(0xff858998),
                fontSize: 16.0,
              ),
              weekendStyle: TextStyle(
                color: Color(0xff858998),
                fontSize: 16.0,
              ),
            ),
          )),
    );
  }
}
