import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'state/user_data.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      'd68e3860-8865-46f9-8339-8ca0d3b248e0',
      '5da57a97-f5d7-4da7-be5c-23f2b71bd3bd',
    ],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  //await NotificationService().init();
  await Firebase.initializeApp();

  final userData = UserData();
  final user = FirebaseAuth.instance.currentUser;
  await userData.initialize(user?.uid);

  runApp(MyApp(userData: userData));
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (context) => userData,
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ), // Lock text scale for all devices
              child: MaterialApp.router(
                routerConfig: router,
                title: 'Morph',
                theme: kLightTheme,
                darkTheme: kDarkTheme,
              ),
            );
          },
        ),
      ),
    );
  }
}
