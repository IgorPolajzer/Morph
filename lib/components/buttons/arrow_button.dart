import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class ArrowButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  bool enabled;

  ArrowButton({
    required this.title,
    required this.onPressed,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: enabled ? onPressed : () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
            Text(
              title,
              style: kConfirmButtonTextStyle.copyWith(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
            Expanded(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 33,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
