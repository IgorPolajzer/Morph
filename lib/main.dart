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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    late UserData userData = UserData();

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
