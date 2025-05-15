import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'config/router_config.dart';
import 'model/user_data.dart';

void main() async {
  print("${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserData userData = UserData();

  @override
  void initState() {
    //FirebaseAuth.instance.signOut();

    // User is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      if (!userData.loading && !userData.isInitialized) {
        userData.pullFromFireBase();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (context) => userData,
      child: SafeArea(
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Morph',
          theme: kLightTheme,
          darkTheme: kDarkTheme,
        ),
      ),
    );
  }
}
