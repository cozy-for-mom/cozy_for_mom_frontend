import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar({super.key});

  @override
  State<WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  var _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      daysOfWeekHeight: 20,
      locale: 'ko_KR',
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
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
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
