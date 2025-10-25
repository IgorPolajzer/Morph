import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class MetaProgressBar extends StatelessWidget {
  final ValueNotifier<double> valueNotifier;
  final double xp;
  final double maxXp;
  final int level;

  const MetaProgressBar({
    required this.valueNotifier,
    required this.xp,
    required this.maxXp,
    required this.level,
    super.key,
  });

  String getTreeAsset() {
    if (level > 9) {
      return "drevo_9_level.png";
    } else {
      return "drevo_${level}_level.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final radius = size / 2;
        final strokeWidth = 32.0;
        final circleSize = 62.0;

        final centerRadius = radius - strokeWidth / 2;

        return Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            DashedCircularProgressBar.aspectRatio(
              aspectRatio: 1,
              valueNotifier: valueNotifier,
              progress: xp,
              maxProgress: maxXp,
              startAngle: 90,
              corners: StrokeCap.round,
              foregroundColor: kMetaLevelColor,
              backgroundColor: Theme.of(
                context,
              ).secondaryHeaderColor.withAlpha(100),
              foregroundStrokeWidth: strokeWidth,
              backgroundStrokeWidth: strokeWidth,
              animation: true,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset("assets/images/tree/${getTreeAsset()}"),
              ),
            ),
            Positioned(
              left: radius + centerRadius - circleSize / 2,
              top: radius - circleSize / 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: kMetaLevelColor, width: 2.0),
                ),
                height: circleSize,
                width: circleSize,
                child: Center(
                  child: Text(
                    "$level lvl",
                    style: kPlaceHolderTextStyle.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
