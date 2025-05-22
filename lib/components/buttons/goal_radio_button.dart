import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class GoalRadioButton extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged checkboxCallback;

  final GestureTapCallback? editOnTap;
  final bool editable;

  const GoalRadioButton({
    required this.isChecked,
    required this.checkboxCallback,
    required this.backgroundColor,
    required this.title,
    required this.description,
    this.editable = false,
    this.editOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: backgroundColor,
              ),
              height: 44,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: kGoalTitleTextStyle.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Checkbox(value: isChecked, onChanged: checkboxCallback),
                  if (editable)
                    GestureDetector(
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: isChecked ? editOnTap : () {},
                    ),
                  if (editable) SizedBox(width: 10),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 60,
              right: 60,
              bottom: 50,
            ),
            child: Text(
              description,
              style: kPlaceHolderTextStyle.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
