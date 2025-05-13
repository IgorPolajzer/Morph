import 'package:flutter/material.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:provider/provider.dart';

import '../components/special/calendar.dart';
import '../model/user_data.dart';

class CalendarScreen extends StatelessWidget {
  static String id = '/calendar__screen';

  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Scaffold(
        body: Calendar(),
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ArrowButton(title: "CONFIRM", onPressed: () {}),
        ),
      ),
    );
  }
}
