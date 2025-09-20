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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final horizontalPadding = maxWidth * 0.08;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding.clamp(8, 32),
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: backgroundColor,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: kGoalTitleTextStyle.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Checkbox(value: isChecked, onChanged: checkboxCallback),
                    if (editable)
                      GestureDetector(
                        child: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: isChecked ? editOnTap : null,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: kPlaceHolderTextStyle.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
