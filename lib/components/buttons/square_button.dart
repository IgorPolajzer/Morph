import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class SquareButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPressed;

  const SquareButton({
    required this.color,
    required this.title,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50.0,
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: kGradientButtonTextSyle.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
