import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/screens/profile_screen.dart';
import 'package:morphe/screens/your_day_screen.dart';

import '../../screens/calendar_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task_alt_outlined), label: ""),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: "",
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFF334192),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) context.go(CalendarScreen.id);
        if (index == 1) context.go(YourDayScreen.id);
        if (index == 2) context.go(ProfileScreen.id);
      },
    );
  }
}
