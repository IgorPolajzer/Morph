import 'package:flutter/material.dart';

import '../components/special/NavBar.dart';

class ProfileScreen extends StatelessWidget {
  static String id = '/profile_screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(body: Placeholder()),
    );
  }
}
