import 'package:flutter/material.dart';
import 'package:morphe/state/connectivity_notifier.dart';
import 'package:morphe/utils/init.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'state/user_data.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var userData = await initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>.value(value: userData),
        ChangeNotifierProvider(create: (_) => ConnectivityNotifier()),
      ],
      child: SafeArea(child: MyApp(userData: userData)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: MaterialApp.router(
            routerConfig: router,
            title: 'Morph',
            theme: kLightTheme,
            darkTheme: kDarkTheme,
          ),
        );
      },
    );
  }
}
