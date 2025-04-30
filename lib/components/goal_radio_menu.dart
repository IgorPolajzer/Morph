import 'package:flutter/material.dart';
import 'package:morphe/constants.dart';

class GoalRadioMenu extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged checkboxCallback;

  const GoalRadioMenu({
    required this.isChecked,
    required this.checkboxCallback,
    required this.backgroundColor,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: backgroundColor,
            ),
            height: 44,
            width: 289,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 21),
                  child: Text(
                    title,
                    style: TextStyle(
                      inherit: false,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                      fontSize: 20,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Checkbox(value: isChecked, onChanged: checkboxCallback),
              ],
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
                color: Theme.of(context).textTheme.displayMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
