import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cozy_for_mom_frontend/model/global_state.dart';
import 'package:provider/provider.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar({super.key});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final globalDate = Provider.of<MyDataModel>(context, listen: true);

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      daysOfWeekHeight: 20,
      locale: 'ko_KR',
      selectedDayPredicate: (date) {
        return isSameDay(date, globalDate.selectedDay);
      },
      calendarStyle: const CalendarStyle(
        weekendTextStyle: TextStyle(
          color: Color(0xff858998),
        ),
        selectedDecoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Color(0xff858998),
        ),
        todayDecoration: BoxDecoration(),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Color(0xff858998),
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          globalDate.updateSelectedDay(selectedDay);
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
