import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/task.dart';
import '../../model/user_data.dart';
import '../lists/daily_task_list.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late ValueNotifier<List<Task>> _selectedTasks = ValueNotifier([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusedDay = _selectedDay;

    final user = Provider.of<UserData>(context, listen: true);
    _selectedTasks.value = user.getTasks(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: true);

    return Column(
      children: [
        TableCalendar<Task>(
          firstDay: DateTime.utc(2024, 1, 4),
          lastDay: DateTime.utc(2035, 1, 4),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                _selectedTasks.value = user.getTasks(selectedDay);
              }
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: (day) {
            return user.getTasks(day);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return SizedBox();

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    events.map((event) {
                      if (event is! Task)
                        return SizedBox.shrink(); // Skip invalid types

                      final task = event as Task;

                      return Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.only(top: 25, right: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.type.getColor(),
                        ),
                      );
                    }).toList(),
              );
            },
          ),
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
            formatButtonDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: Theme.of(context).highlightColor,
                width: 2,
              ),
              color: Theme.of(context).highlightColor.withAlpha(50),
            ),
            formatButtonTextStyle: TextStyle(
              color: Theme.of(context).highlightColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
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
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Task>>(
            valueListenable: _selectedTasks,
            builder: (context, value, _) {
              if (user.loading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return DailyTasksList(tasks: value);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _selectedTasks.dispose();
    super.dispose();
  }
}
