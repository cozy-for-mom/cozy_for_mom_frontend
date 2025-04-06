import 'dart:math';

import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late DateTime _focusedDay;

  @override
  Widget build(BuildContext context) {
    final globalDate = Provider.of<MyDataModel>(context, listen: true);
    _focusedDay = globalDate.selectedDate;

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime.now(),
      calendarFormat: CalendarFormat.week,
      headerVisible: false,
      daysOfWeekHeight: min(20.w, 40),
      locale: 'ko_KR',
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: min(12.sp, 22),
          color: const Color(0xff858998),
        ),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: min(12.sp, 22),
          color: const Color(0xff858998),
        ),
      ),

      selectedDayPredicate: (date) {
        return isSameDay(globalDate.selectedDay, date);
      },
      rowHeight: 40.w,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(
          color: const Color(0xff858998),
          fontSize: min(14.sp, 24),
          fontWeight: FontWeight.w600,
        ),
        selectedDecoration: const BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          fontSize: min(14.sp, 24),
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: min(14.sp, 24),
          color: const Color(0xff858998),
        ),
        todayDecoration: const BoxDecoration(),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: min(14.sp, 24),
          color: const Color(0xff858998),
        ),
        disabledTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: min(14.sp, 24),
          color: const Color(0xffE1E1E7),
        ),
        outsideTextStyle: TextStyle(
          color: const Color(0xffE1E1E7),
          fontWeight: FontWeight.w500,
          fontSize: min(14.sp, 24),
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
