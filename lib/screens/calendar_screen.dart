import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/special/calendar.dart';
import '../model/user_data.dart';

class CalendarScreen extends StatelessWidget {
  static String id = '/calendar_screen';

  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(body: Calendar()),
    );
  }
}
