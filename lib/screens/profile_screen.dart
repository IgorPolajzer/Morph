import 'package:flutter/material.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  static String id = '/profile_screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 65.0,
                right: 65.0,
                top: 65.0,
                bottom: 20,
              ),
              child: DashedCircularProgressBar.aspectRatio(
                aspectRatio: 1, // width ÷ height
                valueNotifier: _valueNotifier,
                progress: 80,
                maxProgress: 100,
                startAngle: 90,
                corners: StrokeCap.round,
                foregroundColor: Color(0xFF00FF6C),
                backgroundColor: const Color(0xFF9F8F8F),
                foregroundStrokeWidth: 32,
                backgroundStrokeWidth: 32,
                animation: true,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset(
                    "assets/images/placeholder_profile_image.png",
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder:
                  (_, double value, __) => Text(
                    '${value.toInt()}/100xp',
                    style: kTitleTextStyle.copyWith(
                      color: Color(0xFF00FF6C),
                      fontSize: 16,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
