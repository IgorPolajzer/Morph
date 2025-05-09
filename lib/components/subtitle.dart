import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

class Subtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const Subtitle({
    required this.title,
    required this.subtitle,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              title,
              style: kTitleTextStyle.copyWith(color: color, fontSize: 24),
            ),
          ),
          Divider(thickness: 2.5, color: color, indent: 50, endIndent: 50),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              subtitle,
              style: kTitleTextStyle.copyWith(color: color, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
