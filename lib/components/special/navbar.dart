import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/screens/profile_screen.dart';
import 'package:morphe/screens/your_day_screen.dart';
import 'package:morphe/utils/constants.dart';

import '../../screens/calendar_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Color selectedColor;

    if (_selectedIndex == 0) {
      selectedColor = kGeneralColor;
    } else if (_selectedIndex == 1) {
      selectedColor = kPhysicalColor;
    } else {
      selectedColor = kMentalColor;
    }

    return Padding(
      padding: EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        child: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Theme.of(context).canvasColor,
          iconSize: 36,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: selectedColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) context.go(CalendarScreen.id);
            if (index == 1) context.go(YourDayScreen.id);
            if (index == 2) context.go(ProfileScreen.id);
          },
        ),
      ),
    );
  }
}
