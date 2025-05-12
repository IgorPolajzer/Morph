import 'package:flutter/material.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:provider/provider.dart';

import '../components/special/calendar.dart';
import '../model/user.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static String id = '/calendar__screen';

  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dataFetched) {
        final user = Provider.of<User>(context, listen: false);
        user.getFromFireBase();
        _dataFetched = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Calendar()],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(title: "CONFIRM", onPressed: () {}),
      ),
    );
  }
}
