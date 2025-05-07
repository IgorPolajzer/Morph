import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import 'package:intl/intl.dart';

import '../utils/enums.dart';

enum Actions { edit, delete }

class HabitTile extends StatelessWidget {
  late String habit;
  late String description;

  HabitTile({required this.habit, required this.description, super.key});

  Actions? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Card(
        shape: StadiumBorder(
          side: BorderSide(
            color: Theme.of(context).extension<CustomColors>()!.headerColor,
            width: 1.0,
          ),
        ),
        color: Theme.of(context).extension<CustomColors>()!.taskTileColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                habit,
                style: kTitleTextStyle.copyWith(
                  color:
                      Theme.of(context).extension<CustomColors>()!.headerColor,
                  fontSize: 24,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Read more",
                  style: kTitleTextStyle.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).extension<CustomColors>()!.headerColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
