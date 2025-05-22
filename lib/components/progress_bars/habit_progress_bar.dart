import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../utils/constants.dart';
import '../../utils/enums.dart';

class HabitProgressBar extends StatelessWidget {
  int xp;
  int level;
  final HabitType type;
  final bool enabled;

  HabitProgressBar({
    required this.xp,
    required this.level,
    required this.type,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50.0, bottom: 4.0),
                child: Row(
                  children: [
                    Text(
                      "${type.format()}: ",
                      style: kPlaceHolderTextStyle.copyWith(
                        color:
                            enabled
                                ? type.getColor()
                                : Theme.of(context).secondaryHeaderColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "$xp/100xp",
                      style: kPlaceHolderTextStyle.copyWith(
                        color:
                            enabled
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).secondaryHeaderColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width - 80,
                lineHeight: 16.0,
                percent: xp / 100,
                backgroundColor: Theme.of(
                  context,
                ).secondaryHeaderColor.withAlpha(100),
                progressColor:
                    enabled
                        ? type.getColor()
                        : Theme.of(context).secondaryHeaderColor.withAlpha(100),
                barRadius: Radius.circular(10),
                animation: true,
              ),
            ],
          ),
          Positioned(
            right: 40,
            top: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        enabled
                            ? type.getColor()
                            : Theme.of(context).secondaryHeaderColor,
                    width: 2.0,
                  ),
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
      ),
    );
  }
}
