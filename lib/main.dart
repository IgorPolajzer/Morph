import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'state/user_data.dart';
import 'state/connectivity_notifier.dart';
import 'config/router_config.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late Future<UserData> _initFuture;
  late Color backgroundColor;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
    backgroundColor = Theme.of(context).scaffoldBackgroundColor;
  }

  Future<UserData> _initializeApp() async {
    // Firebase.
    await Firebase.initializeApp();

    // Mobile Ads.
    await MobileAds.instance.initialize();

    // UserData.
    final userData = UserData();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    await userData.initialize(uid);

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: backgroundColor,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Initialization failed.\n${snapshot.error}'),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: snapshot.data!),
            ChangeNotifierProvider(create: (_) => ConnectivityNotifier()),
          ],
          child: const MyApp(),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Morph',
        theme: kLightTheme,
        darkTheme: kDarkTheme,
      ),
    );
  }
}
