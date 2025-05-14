import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/screens/calendar_screen.dart';
import 'package:morphe/screens/profile_screen.dart';
import 'package:morphe/screens/your_day_screen.dart';
import 'package:morphe/screens/choose_goals_screen.dart';
import 'package:morphe/screens/describe_your_goals.dart';
import 'package:morphe/screens/login_screen.dart';
import 'package:morphe/screens/plan_overview_screen.dart';
import 'package:morphe/screens/registration_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';
import 'package:morphe/utils/enums.dart';

import '../components/special/NavBar.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }
}

final authNotifier = AuthNotifier();

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

/// The route configuration.
final GoRouter router = GoRouter(
  refreshListenable: authNotifier,
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder:
          (context, state, child) =>
              Scaffold(body: child, bottomNavigationBar: Navbar()),
      routes: [
        GoRoute(
          path: CalendarScreen.id,
          builder: (context, state) => const CalendarScreen(),
        ),
        GoRoute(
          path: YourDayScreen.id,
          builder: (context, state) => const YourDayScreen(),
        ),
        GoRoute(
          path: ProfileScreen.id,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/',
      builder: (context, state) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    ),
    GoRoute(
      path: WelcomeScreen.id,
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomeScreen();
      },
    ),
    GoRoute(
      path: RegistrationScreen.id,
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationScreen();
      },
    ),
    GoRoute(
      path: LoginScreen.id,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: ChooseGoalsScreen.id,
      builder: (BuildContext context, GoRouterState state) {
        return const ChooseGoalsScreen();
      },
    ),
    GoRoute(
      path: DescribeYourGoalsScreen.id,
      builder: (BuildContext context, GoRouterState state) {
        return const DescribeYourGoalsScreen();
      },
    ),
    GoRoute(
      path: PlanOverviewScreen.id_physical,
      builder: (BuildContext context, GoRouterState state) {
        return const PlanOverviewScreen(type: HabitType.PHYSICAL);
      },
    ),
    GoRoute(
      path: PlanOverviewScreen.id_general,
      builder: (BuildContext context, GoRouterState state) {
        return const PlanOverviewScreen(type: HabitType.GENERAL);
      },
    ),
    GoRoute(
      path: PlanOverviewScreen.id_mental,
      builder: (BuildContext context, GoRouterState state) {
        return const PlanOverviewScreen(type: HabitType.MENTAL);
      },
    ),
  ],
  initialLocation: '/',
  redirect: (context, state) {
    //FirebaseAuth.instance.signOut();
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthPage =
        state.fullPath == LoginScreen.id ||
        state.fullPath == RegistrationScreen.id;
    final isInitalLocation = state.fullPath == '/';
    final isOnboardingPage =
        state.fullPath == ChooseGoalsScreen.id ||
        state.fullPath == DescribeYourGoalsScreen.id ||
        state.fullPath == PlanOverviewScreen.id_physical ||
        state.fullPath == PlanOverviewScreen.id_general ||
        state.fullPath == PlanOverviewScreen.id_mental;

    if (!isLoggedIn && !isAuthPage && !isOnboardingPage) {
      // Not logged in and trying to go somewhere protected
      return WelcomeScreen.id;
    }

    if (isLoggedIn && isInitalLocation) {
      // Logged in coming from initial page
      return CalendarScreen.id;
    }

    // Otherwise allow navigation
    return null;
  },
);
