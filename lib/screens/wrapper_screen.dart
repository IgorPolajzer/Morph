import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morphe/screens/physical_plan_overview_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';

class WrapperScreen extends StatelessWidget {
  static String id = '/wrapper_screen';

  const WrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else {
            if (snapshot.data == null) {
              return WelcomeScreen();
            } else {
              return PhysicalPlanOverviewScreen();
            }
          }
        },
      ),
    );
  }
}
