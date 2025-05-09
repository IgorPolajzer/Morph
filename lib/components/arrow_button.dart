import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class ArrowButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ArrowButton({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
            Text(
              title,
              style: kConfirmButtonTextStyle.copyWith(
                color: Theme.of(
                  context,
                ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(
                context,
              ).extension<CustomColors>()!.headerColor.withValues(alpha: 0.5),
              size: 33,
            ),
          ],
        ),
      ),
    );
  }
}
