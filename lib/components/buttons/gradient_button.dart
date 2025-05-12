import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class GradientButton extends StatelessWidget {
  final Gradient myGradient;
  final String title;
  final VoidCallback onPressed;

  const GradientButton({
    required this.myGradient,
    required this.title,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: myGradient,
            borderRadius: const BorderRadius.all(Radius.circular(80.0)),
          ),
          child: SizedBox(
            height: 50,
            width: 180,
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
