import 'package:flutter/material.dart';

class YourDayScreen extends StatelessWidget {
  static String id = '/your_day_screen';

  const YourDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(body: Placeholder()),
    );
  }
}
