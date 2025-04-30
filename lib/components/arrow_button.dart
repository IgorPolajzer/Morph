import 'package:flutter/material.dart';
import 'package:morphe/constants.dart';

class ArrowButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const ArrowButton({required this.title, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  title,
                  style: kConfirmButtonTextStyle.copyWith(
                    color: Theme.of(context).textTheme.displayMedium?.color,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.displaySmall?.color,
                size: 33,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
