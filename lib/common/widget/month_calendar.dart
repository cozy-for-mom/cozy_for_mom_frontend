import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    final globalDate = Provider.of<MyDataModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
          width: screenWidth - 40,
          child: TableCalendar(
            focusedDay: globalDate.selectedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime.now(),
            eventLoader: (date) => _events[date] ?? [],
            selectedDayPredicate: (date) {
              return isSameDay(date, globalDate.selectedDay);
            },
            onDaySelected: (date, events) {
              setState(() {
                // _selectedDay = date;
                globalDate.updateSelectedDay(date);
              });
            },
            locale: 'ko-KR',
            availableGestures: AvailableGestures.horizontalSwipe,
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              defaultTextStyle: TextStyle(
                color: offButtonTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              outsideTextStyle: TextStyle(
                color: Color(0xffE3E3E3),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromRGBO(92, 166, 248, 128), // 오늘 날짜 마크 색상
                shape: BoxShape.circle, // 원 모양 마크
              ),
              selectedDecoration: BoxDecoration(
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
              titleTextStyle: const TextStyle(
                  color: mainTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
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
                color: offButtonTextColor,
                fontSize: 16.0,
              ),
              weekendStyle: TextStyle(
                color: offButtonTextColor,
                fontSize: 16.0,
              ),
            ),
          )),
    );
  }
}

class MonthCalendarModal extends StatelessWidget {
  const MonthCalendarModal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: AlignmentDirectional.centerEnd,
            margin: const EdgeInsets.only(bottom: 15),
            height: 20,
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
              padding: const EdgeInsets.only(
                  top: 20, bottom: 40, left: 20, right: 20),
              width: screenWidth,
              height: screenHeight * (0.7),
              child: ChangeNotifierProvider(
                create: (context) => MyDataModel(),
                child: const MonthCalendar(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
