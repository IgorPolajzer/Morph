import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/screens/calendar_screen.dart';
import 'package:morphe/screens/plan_overview_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../model/user_data.dart';
import '../utils/enums.dart';

class AuthWrapperScreen extends StatelessWidget {
  static String id = '/wrapper_screen';

  const AuthWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //FirebaseAuth.instance.signOut();

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else if (!snapshot.hasData) {
            return WelcomeScreen();
          } else {
            // User is logged in
            final userData = Provider.of<UserData>(context, listen: false);

            // If not already loaded, fetch from Firebase
            if (!userData.loading && !userData.isInitialized) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                userData.pullFromFireBase();
              });
            }

            // Let GoRouter handle the routing based on auth state
            return const SizedBox.shrink(); // Nothing to render
          }
        },
      ),
    );
  }
}
