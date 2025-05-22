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
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      clipBehavior: Clip.none,
      children: [
        DashedCircularProgressBar.aspectRatio(
          aspectRatio: 1, // width ÷ height
          valueNotifier: valueNotifier,
          progress: xp,
          maxProgress: maxXp,
          startAngle: 90,
          corners: StrokeCap.round,
          foregroundColor: kMetaLevelColor,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          foregroundStrokeWidth: 32,
          backgroundStrokeWidth: 32,
          animation: true,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset("assets/images/tree/${getTreeAsset()}"),
          ),
        ),
        Positioned(
          left: 210,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: kMetaLevelColor, width: 2.0),
              ),
              height: 62,
              width: 62,
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
        ),
      ],
    );
  }
}
