import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/screens/core/calendar_screen.dart';
import 'package:morphe/screens/core/your_day_screen.dart';
import 'package:morphe/screens/edit/edit_plan_screen.dart';
import 'package:morphe/screens/onboarding/login_screen.dart';
import 'package:morphe/utils/enums.dart';

import '../components/special/navbar.dart';
import '../screens/core/profile_screen.dart';
import '../screens/edit/change_habits_screen.dart';
import '../screens/onboarding/choose_goals_screen.dart';
import '../screens/onboarding/describe_your_goals.dart';
import '../screens/onboarding/plan_overview_screen.dart';
import '../screens/onboarding/registration_screen.dart';
import '../screens/onboarding/welcome_screen.dart';

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
          builder: (context, state) => YourDayScreen(),
        ),
        GoRoute(
          path: ProfileScreen.id,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: ChangeHabitsScreen.id,
          builder: (context, state) => const ChangeHabitsScreen(),
        ),
        GoRoute(
          path: EditPlanScreen.id_physical,
          builder:
              (context, state) =>
                  const EditPlanScreen(type: HabitType.PHYSICAL),
        ),
        GoRoute(
          path: EditPlanScreen.id_general,
          builder:
              (context, state) => const EditPlanScreen(type: HabitType.GENERAL),
        ),
        GoRoute(
          path: EditPlanScreen.id_mental,
          builder:
              (context, state) => const EditPlanScreen(type: HabitType.MENTAL),
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
      return YourDayScreen.id;
    }

    // Otherwise allow navigation
    return null;
  },
);
