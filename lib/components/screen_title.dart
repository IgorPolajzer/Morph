import 'package:flutter/material.dart';
import 'package:morphe/constants.dart';

class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 63, left: 73, right: 73),
      child: Text(
        title,
        style: kTitleTextStyle.copyWith(
          color: Theme.of(context).textTheme.displayLarge?.color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
