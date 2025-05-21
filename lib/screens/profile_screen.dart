import 'package:flutter/material.dart';
import 'package:morphe/components/progress_bars/meta_progress_bar.dart';
import 'package:morphe/model/experience.dart';
import 'package:provider/provider.dart';

import '../components/progress_bars/habit_progress_bar.dart';
import '../model/user_data.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

class ProfileScreen extends StatefulWidget {
  static String id = '/profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  late Map _selectedHabits = {};
  late Map<HabitType, Experience> _experience = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);
    _selectedHabits = userData.selectedHabits;
    _experience = userData.experience;
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    final metaXp = Experience.getMetaXp(_experience);

    final maxMetaXp = Experience.getMetaMaxXp(_experience);

    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 65.0,
                right: 65.0,
                bottom: 20,
              ),
              child: MetaProgressBar(
                valueNotifier: _valueNotifier,
                xp: metaXp.roundToDouble(),
                maxXp: maxMetaXp.roundToDouble(),
                level: userData.metaLevel,
              ),
            ),
            Text(
              '$metaXp/300xp',
              style: kTitleTextStyle.copyWith(
                color: kMetaLevelColor,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Text(
                userData.username,
                style: kTitleTextStyle.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 38,
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
    );
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }
}
