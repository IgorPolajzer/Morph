import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/progress_bars/meta_progress_bar.dart';
import 'package:morphe/model/experience.dart';
import 'package:morphe/screens/edit/change_goals_screen.dart';
import 'package:provider/provider.dart';

import '../../components/progress_bars/habit_progress_bar.dart';
import '../../model/user_data.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';

class ProfileScreen extends StatefulWidget {
  static String id = '/profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  late int maxMetaXp;

  late Map _selectedHabits = {};
  late Map<HabitType, Experience> _experience = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);

    _selectedHabits = userData.selectedHabits;
    _experience = userData.experience;

    maxMetaXp = Experience.getMetaMaxXp(_experience);

    userData.updateMetaLevel(Experience.getMetaXp(_experience), (level) => 300);
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 65.0, right: 65.0),
                      child: MetaProgressBar(
                        valueNotifier: _valueNotifier,
                        xp: userData.metaXp.roundToDouble(),
                        maxXp: maxMetaXp.roundToDouble(),
                        level: userData.metaLevel,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 50,
                      ),
                      child: Text(
                        userData.username,
                        style: kTitleTextStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 38,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        '${userData.metaXp}/${maxMetaXp}xp',
                        style: kTitleTextStyle.copyWith(
                          color: kMetaLevelColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    HabitProgressBar(
                      xp: _experience[HabitType.PHYSICAL]!.points,
                      level: _experience[HabitType.PHYSICAL]!.level,
                      type: HabitType.PHYSICAL,
                      enabled: _selectedHabits[HabitType.PHYSICAL],
                    ),
                    HabitProgressBar(
                      xp: _experience[HabitType.GENERAL]!.points,
                      level: _experience[HabitType.GENERAL]!.level,
                      type: HabitType.GENERAL,
                      enabled: _selectedHabits[HabitType.GENERAL],
                    ),
                    HabitProgressBar(
                      xp: _experience[HabitType.MENTAL]!.points,
                      level: _experience[HabitType.MENTAL]!.level,
                      type: HabitType.MENTAL,
                      enabled: _selectedHabits[HabitType.MENTAL],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextButton(
                    onPressed: () {
                      context.push(ChangeGoalsScreen.id);
                    },
                    child: Icon(Icons.settings_outlined, size: 38),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextButton(
                    onPressed: () {
                      showCupertinoDialog<void>(
                        context: context,
                        builder:
                            (BuildContext context) => CupertinoAlertDialog(
                              title: const Text('Log out'),
                              content: const Text(
                                "Are you sure you want to log out?",
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    userData.reset();
                                  },
                                  child: const Text('Log out'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Icon(Icons.login_outlined, size: 38),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }
}
