import 'package:cozy_for_mom_frontend/common/custom_color.dart';
import 'package:cozy_for_mom_frontend/utils/app_utils.dart';
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
      daysOfWeekHeight: 20,
      locale: 'ko_KR',
      selectedDayPredicate: (date) {
        return isSameDay(globalDate.selectedDay, date);
      },
      calendarStyle: CalendarStyle(
        weekendTextStyle: const TextStyle(
          color: Color(0xff858998),
        ),
        selectedDecoration: const BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppUtils.scaleSize(context, 15),
          color: const Color(0xff858998),
        ),
        todayDecoration: const BoxDecoration(),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppUtils.scaleSize(context, 15),
          color: const Color(0xff858998),
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
