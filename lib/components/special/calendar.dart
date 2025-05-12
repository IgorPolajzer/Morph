import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/constants.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 1, 4),
      lastDay: DateTime.utc(2035, 1, 4),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Theme.of(context).highlightColor.withAlpha(80),
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(color: Theme.of(context).primaryColor),
        outsideTextStyle: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        defaultTextStyle: TextStyle(color: Theme.of(context).primaryColor),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Theme.of(context).highlightColor,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          color: Theme.of(context).highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
