import 'package:flutter/material.dart';
import 'package:morphe/components/progress_bars/meta_progress_bar.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);
    //_selectedTasks.value = userData.getTasks(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

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
              child: MetaProgressBar(valueNotifier: _valueNotifier),
            ),
            Text(
              '80/100xp',
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
            HabitProgressBar(xp: 20, level: 3, type: HabitType.PHYSICAL),
            HabitProgressBar(xp: 30, level: 3, type: HabitType.GENERAL),
            HabitProgressBar(xp: 60, level: 3, type: HabitType.MENTAL),
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
